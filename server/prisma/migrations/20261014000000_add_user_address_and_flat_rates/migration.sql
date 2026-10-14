-- AlterTable
ALTER TABLE "users" ADD COLUMN     "address" TEXT;

-- AlterTable
ALTER TABLE "tax_profiles" ADD COLUMN     "flat_rate" DECIMAL(6,4),
ADD COLUMN     "rent_relief_rate" DECIMAL(6,4);
