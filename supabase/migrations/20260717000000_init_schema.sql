-- Activer l'extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CHARACTERS
CREATE TABLE public.characters (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    player_name TEXT NOT NULL DEFAULT '',
    ruleset TEXT NOT NULL,
    alignment TEXT NOT NULL DEFAULT '',
    xp INT NOT NULL DEFAULT 0,
    species_id TEXT,
    subspecies_id TEXT,
    background_id TEXT,
    hp_max INT NOT NULL DEFAULT 0,
    hp_current INT NOT NULL DEFAULT 0,
    hp_temp INT NOT NULL DEFAULT 0,
    armor_class INT NOT NULL DEFAULT 10,
    speed INT NOT NULL DEFAULT 30,
    exhaustion_level INT NOT NULL DEFAULT 0,
    heroic_inspiration BOOLEAN NOT NULL DEFAULT false,
    death_save_successes INT NOT NULL DEFAULT 0,
    death_save_failures INT NOT NULL DEFAULT 0,
    personality_traits TEXT NOT NULL DEFAULT '',
    ideals TEXT NOT NULL DEFAULT '',
    bonds TEXT NOT NULL DEFAULT '',
    flaws TEXT NOT NULL DEFAULT '',
    backstory TEXT NOT NULL DEFAULT '',
    appearance TEXT NOT NULL DEFAULT '',
    currency TEXT NOT NULL DEFAULT '{"cp":0,"sp":0,"ep":0,"gp":0,"pp":0}',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

ALTER TABLE public.characters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Utilisateurs peuvent gerer leurs propres personnages" ON public.characters FOR ALL USING (auth.uid() = user_id);

-- 2. CHARACTER CLASSES
CREATE TABLE public.character_classes (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    class_id TEXT NOT NULL,
    subclass_id TEXT,
    level INT NOT NULL
);

ALTER TABLE public.character_classes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_classes" ON public.character_classes FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_classes.character_id AND characters.user_id = auth.uid())
);

-- 3. CHARACTER ABILITY SCORES
CREATE TABLE public.character_ability_scores (
    id SERIAL PRIMARY KEY,
    character_id INT UNIQUE NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    strength INT NOT NULL DEFAULT 10,
    dexterity INT NOT NULL DEFAULT 10,
    constitution INT NOT NULL DEFAULT 10,
    intelligence INT NOT NULL DEFAULT 10,
    wisdom INT NOT NULL DEFAULT 10,
    charisma INT NOT NULL DEFAULT 10
);

ALTER TABLE public.character_ability_scores ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_ability_scores" ON public.character_ability_scores FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_ability_scores.character_id AND characters.user_id = auth.uid())
);

-- 4. CHARACTER PROFICIENCIES
CREATE TABLE public.character_proficiencies (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    proficiency_key TEXT NOT NULL,
    has_expertise BOOLEAN NOT NULL DEFAULT false
);

ALTER TABLE public.character_proficiencies ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_proficiencies" ON public.character_proficiencies FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_proficiencies.character_id AND characters.user_id = auth.uid())
);

-- 5. CHARACTER SPELLS
CREATE TABLE public.character_spells (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    spell_id TEXT NOT NULL,
    ruleset TEXT NOT NULL,
    prepared BOOLEAN NOT NULL DEFAULT false,
    always_prepared BOOLEAN NOT NULL DEFAULT false
);

ALTER TABLE public.character_spells ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_spells" ON public.character_spells FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_spells.character_id AND characters.user_id = auth.uid())
);

-- 6. CHARACTER FEATS
CREATE TABLE public.character_feats (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    feat_id TEXT NOT NULL,
    ruleset TEXT NOT NULL,
    choices_json TEXT
);

ALTER TABLE public.character_feats ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_feats" ON public.character_feats FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_feats.character_id AND characters.user_id = auth.uid())
);

-- 7. CHARACTER SPELL SLOTS
CREATE TABLE public.character_spell_slots (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    slot_level INT NOT NULL,
    slot_max INT NOT NULL,
    slot_current INT NOT NULL
);

ALTER TABLE public.character_spell_slots ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_spell_slots" ON public.character_spell_slots FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_spell_slots.character_id AND characters.user_id = auth.uid())
);

-- 8. CHARACTER RESOURCES
CREATE TABLE public.character_resources (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    resource_name TEXT NOT NULL,
    current INT NOT NULL,
    maximum INT NOT NULL
);

ALTER TABLE public.character_resources ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_resources" ON public.character_resources FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_resources.character_id AND characters.user_id = auth.uid())
);

-- 9. CHARACTER ATTACKS
CREATE TABLE public.character_attacks (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    attack_bonus TEXT NOT NULL,
    damage_dice TEXT NOT NULL,
    damage_type TEXT NOT NULL,
    mastery_property TEXT,
    notes TEXT NOT NULL DEFAULT ''
);

ALTER TABLE public.character_attacks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_attacks" ON public.character_attacks FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_attacks.character_id AND characters.user_id = auth.uid())
);

-- 10. CHARACTER EQUIPMENT
CREATE TABLE public.character_equipment (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    item_name TEXT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    weight REAL NOT NULL DEFAULT 0.0,
    equipped BOOLEAN NOT NULL DEFAULT false,
    attuned BOOLEAN NOT NULL DEFAULT false,
    notes TEXT NOT NULL DEFAULT ''
);

ALTER TABLE public.character_equipment ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access character_equipment" ON public.character_equipment FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_equipment.character_id AND characters.user_id = auth.uid())
);

-- 11. BATMAN CHARACTERS
CREATE TABLE public.batman_characters (
    id SERIAL PRIMARY KEY,
    character_id INT UNIQUE NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    profile_id TEXT NOT NULL,
    secret_identity TEXT NOT NULL DEFAULT '',
    mode TEXT NOT NULL DEFAULT '',
    force INT NOT NULL DEFAULT 8,
    constitution INT NOT NULL DEFAULT 8,
    dexterite INT NOT NULL DEFAULT 8,
    intelligence INT NOT NULL DEFAULT 8,
    perception INT NOT NULL DEFAULT 8,
    volonte INT NOT NULL DEFAULT 8,
    atc_total INT NOT NULL DEFAULT 0,
    atd_total INT NOT NULL DEFAULT 0,
    defense INT NOT NULL DEFAULT 10,
    initiative INT NOT NULL DEFAULT 0,
    exploit_points_current INT NOT NULL DEFAULT 0,
    exploit_points_max INT NOT NULL DEFAULT 0,
    ethics_order INT NOT NULL DEFAULT 0,
    ethics_justice INT NOT NULL DEFAULT 0,
    ethics_anarchy INT NOT NULL DEFAULT 0,
    ethics_crime INT NOT NULL DEFAULT 0,
    living_standard TEXT NOT NULL DEFAULT 'modeste'
);

ALTER TABLE public.batman_characters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access batman_characters" ON public.batman_characters FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = batman_characters.character_id AND characters.user_id = auth.uid())
);

-- 12. BATMAN CHARACTER WAYS
CREATE TABLE public.batman_character_ways (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    way_id TEXT NOT NULL,
    rank_acquired INT NOT NULL DEFAULT 1,
    acquired_capabilities TEXT NOT NULL DEFAULT '[]'
);

ALTER TABLE public.batman_character_ways ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Access batman_character_ways" ON public.batman_character_ways FOR ALL USING (
    EXISTS (SELECT 1 FROM public.characters WHERE characters.id = batman_character_ways.character_id AND characters.user_id = auth.uid())
);