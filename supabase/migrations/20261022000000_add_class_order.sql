-- Ordre divin (Clerc) / ordre primordial (Druide) du D&D 2024.
-- Valeurs : protector, thaumaturge (Clerc) ; magician, warden (Druide).
-- NULL = pas de choix enregistré (2014, autres classes, personnages existants).
ALTER TABLE public.character_classes
    ADD COLUMN IF NOT EXISTS class_order TEXT;
