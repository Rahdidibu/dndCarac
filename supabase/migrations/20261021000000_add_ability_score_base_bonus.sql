-- Décomposition des caractéristiques : final = base + bonus d'origine.
-- Les colonnes strength..charisma restent les valeurs finales (lues partout).
-- NULL = non enregistré (personnages créés avant cette migration).
ALTER TABLE public.character_ability_scores
    ADD COLUMN IF NOT EXISTS base_strength INT,
    ADD COLUMN IF NOT EXISTS base_dexterity INT,
    ADD COLUMN IF NOT EXISTS base_constitution INT,
    ADD COLUMN IF NOT EXISTS base_intelligence INT,
    ADD COLUMN IF NOT EXISTS base_wisdom INT,
    ADD COLUMN IF NOT EXISTS base_charisma INT,
    ADD COLUMN IF NOT EXISTS bonus_strength INT,
    ADD COLUMN IF NOT EXISTS bonus_dexterity INT,
    ADD COLUMN IF NOT EXISTS bonus_constitution INT,
    ADD COLUMN IF NOT EXISTS bonus_intelligence INT,
    ADD COLUMN IF NOT EXISTS bonus_wisdom INT,
    ADD COLUMN IF NOT EXISTS bonus_charisma INT;
