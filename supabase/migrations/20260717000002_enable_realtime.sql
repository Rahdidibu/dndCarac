-- Supprime et recrée la publication supabase_realtime pour y ajouter nos tables
-- Cela permet d'activer le mode Realtime sur ces tables pour l'application Flutter.
DROP PUBLICATION IF EXISTS supabase_realtime;

CREATE PUBLICATION supabase_realtime FOR TABLE 
  public.characters, 
  public.character_classes,
  public.character_ability_scores,
  public.character_proficiencies,
  public.character_spells,
  public.character_feats,
  public.character_spell_slots,
  public.character_resources,
  public.character_attacks,
  public.character_equipment,
  public.batman_characters,
  public.batman_character_ways;
