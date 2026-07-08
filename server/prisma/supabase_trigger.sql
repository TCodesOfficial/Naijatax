-- 1. Create a trigger function that copies user signup entries from auth.users to public.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
SECURITY DEFINER SET search_path = public
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO public.users (id, email, phone, "display_name", "avatar_url", onboarded, role, "createdAt", "updatedAt")
  VALUES (
    new.id,
    new.email,
    new.phone,
    COALESCE(new.raw_user_meta_data ->> 'display_name', new.raw_user_meta_data ->> 'name'),
    COALESCE(new.raw_user_meta_data ->> 'avatar_url', new.raw_user_meta_data ->> 'picture'),
    false,
    'USER',
    now(),
    now()
  )
  ON CONFLICT (id) DO UPDATE SET
    phone = COALESCE(EXCLUDED.phone, public.users.phone),
    "display_name" = COALESCE(EXCLUDED."display_name", public.users."display_name"),
    "avatar_url" = COALESCE(EXCLUDED."avatar_url", public.users."avatar_url");
  RETURN new;
END;
$$;

-- 2. Create the trigger to execute public.handle_new_user() when a user signs up
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
