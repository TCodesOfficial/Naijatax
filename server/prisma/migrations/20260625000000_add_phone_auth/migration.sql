-- AlterTable: Add phone, displayName to users; make email optional
ALTER TABLE "users" ADD COLUMN "phone" TEXT,
ADD COLUMN "display_name" TEXT;

-- CreateIndex: Unique constraint on phone
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- AlterTable: Make email nullable for phone-based auth
ALTER TABLE "users" ALTER COLUMN "email" DROP NOT NULL;
