-- Migration for character_notes table
CREATE TABLE IF NOT EXISTS public.character_notes (
    id SERIAL PRIMARY KEY,
    character_id INT NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
    category TEXT NOT NULL DEFAULT 'journal',
    title TEXT NOT NULL DEFAULT '',
    content TEXT NOT NULL DEFAULT '',
    is_pinned BOOLEAN NOT NULL DEFAULT false,
    created_at TEXT NOT NULL DEFAULT '',
    updated_at TEXT NOT NULL DEFAULT ''
);

ALTER TABLE public.character_notes ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'character_notes' AND policyname = 'Access character_notes'
    ) THEN
        CREATE POLICY "Access character_notes" ON public.character_notes FOR ALL USING (
            EXISTS (SELECT 1 FROM public.characters WHERE characters.id = character_notes.character_id AND characters.user_id = auth.uid())
        );
    END IF;
END $$;
