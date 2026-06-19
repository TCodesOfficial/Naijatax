-- 1. Create a trigger function that copies user signup entries from auth.users to public.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
SECURITY DEFINER SET search_path = public
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO public.users (id, email, role, "createdAt", "updatedAt")
  VALUES (new.id, new.email, 'USER', now(), now())
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$;

-- 2. Create the trigger to execute public.handle_new_user() when a user signs up
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
