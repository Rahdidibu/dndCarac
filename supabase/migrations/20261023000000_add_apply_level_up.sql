-- Montée de niveau atomique : toutes les écritures d'une montée de niveau
-- s'exécutent dans la transaction implicite de cette fonction. Une erreur ou
-- une coupure réseau annule l'ensemble.
--
-- Charge utile (JSONB), calculée côté application par `LevelUpPlan` :
--   class            {id?, class_id, subclass_id?, level}   id absent = nouvelle classe
--   expected_level   niveau de la classe avant la montée (null pour une nouvelle classe)
--   character        {hp_max, hp_current, armor_class, updated_at}
--   ability_scores   {strength.., base_strength.., bonus_strength..} (optionnel)
--   proficiencies    ["skill_stealth", ...]                           (optionnel)
--   feat             {feat_id, ruleset}                               (optionnel)
--   resources        [{resource_name, current, maximum}, ...]         (optionnel)
--   spell_slots      [{slot_level, slot_max, slot_current}, ...]      (optionnel, remplace tout)
--
-- SECURITY INVOKER : les politiques RLS de l'utilisateur s'appliquent.
CREATE OR REPLACE FUNCTION public.apply_level_up(
    p_character_id INT,
    p_payload JSONB
) RETURNS VOID
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
    v_class JSONB := p_payload -> 'class';
    v_expected INT := NULLIF(p_payload ->> 'expected_level', '')::INT;
    v_class_row_id INT := NULLIF(v_class ->> 'id', '')::INT;
    v_scores JSONB := p_payload -> 'ability_scores';
    v_char JSONB := p_payload -> 'character';
    v_feat JSONB := p_payload -> 'feat';
    v_count INT;
BEGIN
    -- Verrouille le personnage : deux montées de niveau simultanées s'enchaînent.
    PERFORM 1 FROM public.characters WHERE id = p_character_id FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'level_up_character_not_found' USING ERRCODE = 'P0002';
    END IF;

    -- Classe : le niveau doit être celui lu avant le calcul (anti double application).
    IF v_class_row_id IS NULL THEN
        IF EXISTS (
            SELECT 1 FROM public.character_classes
            WHERE character_id = p_character_id AND class_id = v_class ->> 'class_id'
        ) THEN
            RAISE EXCEPTION 'level_up_conflict' USING ERRCODE = 'P0001';
        END IF;
        INSERT INTO public.character_classes (character_id, class_id, subclass_id, level)
        VALUES (
            p_character_id,
            v_class ->> 'class_id',
            NULLIF(v_class ->> 'subclass_id', ''),
            (v_class ->> 'level')::INT
        );
    ELSE
        UPDATE public.character_classes
        SET level = (v_class ->> 'level')::INT,
            subclass_id = NULLIF(v_class ->> 'subclass_id', '')
        WHERE id = v_class_row_id
          AND character_id = p_character_id
          AND level = v_expected;
        GET DIAGNOSTICS v_count = ROW_COUNT;
        IF v_count <> 1 THEN
            RAISE EXCEPTION 'level_up_conflict' USING ERRCODE = 'P0001';
        END IF;
    END IF;

    -- Caractéristiques (valeurs finales et décomposition base/bonus).
    IF v_scores IS NOT NULL AND jsonb_typeof(v_scores) = 'object' THEN
        UPDATE public.character_ability_scores SET
            strength = (v_scores ->> 'strength')::INT,
            dexterity = (v_scores ->> 'dexterity')::INT,
            constitution = (v_scores ->> 'constitution')::INT,
            intelligence = (v_scores ->> 'intelligence')::INT,
            wisdom = (v_scores ->> 'wisdom')::INT,
            charisma = (v_scores ->> 'charisma')::INT,
            base_strength = (v_scores ->> 'base_strength')::INT,
            base_dexterity = (v_scores ->> 'base_dexterity')::INT,
            base_constitution = (v_scores ->> 'base_constitution')::INT,
            base_intelligence = (v_scores ->> 'base_intelligence')::INT,
            base_wisdom = (v_scores ->> 'base_wisdom')::INT,
            base_charisma = (v_scores ->> 'base_charisma')::INT,
            bonus_strength = (v_scores ->> 'bonus_strength')::INT,
            bonus_dexterity = (v_scores ->> 'bonus_dexterity')::INT,
            bonus_constitution = (v_scores ->> 'bonus_constitution')::INT,
            bonus_intelligence = (v_scores ->> 'bonus_intelligence')::INT,
            bonus_wisdom = (v_scores ->> 'bonus_wisdom')::INT,
            bonus_charisma = (v_scores ->> 'bonus_charisma')::INT
        WHERE character_id = p_character_id;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'level_up_scores_not_found' USING ERRCODE = 'P0002';
        END IF;
    END IF;

    -- Maîtrises : jamais de doublon.
    IF jsonb_typeof(p_payload -> 'proficiencies') = 'array' THEN
        INSERT INTO public.character_proficiencies (character_id, proficiency_key)
        SELECT DISTINCT p_character_id, k.proficiency_key
        FROM jsonb_array_elements_text(p_payload -> 'proficiencies') AS k(proficiency_key)
        WHERE NOT EXISTS (
            SELECT 1 FROM public.character_proficiencies existing
            WHERE existing.character_id = p_character_id
              AND existing.proficiency_key = k.proficiency_key
        );
    END IF;

    -- Don.
    IF v_feat IS NOT NULL AND jsonb_typeof(v_feat) = 'object' THEN
        INSERT INTO public.character_feats (character_id, feat_id, ruleset)
        VALUES (p_character_id, v_feat ->> 'feat_id', v_feat ->> 'ruleset');
    END IF;

    -- Ressources : mise à jour par nom, création si absente.
    IF jsonb_typeof(p_payload -> 'resources') = 'array' THEN
        UPDATE public.character_resources r
        SET current = v.current, maximum = v.maximum
        FROM jsonb_to_recordset(p_payload -> 'resources')
            AS v(resource_name TEXT, current INT, maximum INT)
        WHERE r.character_id = p_character_id AND r.resource_name = v.resource_name;

        INSERT INTO public.character_resources (character_id, resource_name, current, maximum)
        SELECT p_character_id, v.resource_name, v.current, v.maximum
        FROM jsonb_to_recordset(p_payload -> 'resources')
            AS v(resource_name TEXT, current INT, maximum INT)
        WHERE NOT EXISTS (
            SELECT 1 FROM public.character_resources r
            WHERE r.character_id = p_character_id AND r.resource_name = v.resource_name
        );
    END IF;

    -- Emplacements de sorts : remplacement complet dans la même transaction.
    IF jsonb_typeof(p_payload -> 'spell_slots') = 'array' THEN
        DELETE FROM public.character_spell_slots WHERE character_id = p_character_id;
        INSERT INTO public.character_spell_slots (character_id, slot_level, slot_max, slot_current)
        SELECT p_character_id, v.slot_level, v.slot_max, v.slot_current
        FROM jsonb_to_recordset(p_payload -> 'spell_slots')
            AS v(slot_level INT, slot_max INT, slot_current INT);
    END IF;

    -- PV, CA et date de mise à jour du personnage.
    UPDATE public.characters SET
        hp_max = (v_char ->> 'hp_max')::INT,
        hp_current = (v_char ->> 'hp_current')::INT,
        armor_class = (v_char ->> 'armor_class')::INT,
        updated_at = v_char ->> 'updated_at'
    WHERE id = p_character_id;
END;
$$;

REVOKE ALL ON FUNCTION public.apply_level_up(INT, JSONB) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.apply_level_up(INT, JSONB) TO authenticated;
