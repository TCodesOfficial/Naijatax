-- AlterTable
ALTER TABLE "tax_profiles" ADD COLUMN     "assets" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
ADD COLUMN     "turnover" DECIMAL(15,2) NOT NULL DEFAULT 0.00;

-- CreateIndex
CREATE INDEX "tax_articles_category_idx" ON "tax_articles"("category");

-- CreateIndex
CREATE INDEX "tax_articles_created_at_idx" ON "tax_articles"("created_at" DESC);

-- CreateIndex
CREATE INDEX "tax_articles_is_featured_created_at_idx" ON "tax_articles"("is_featured", "created_at" DESC);

-- CreateIndex
CREATE INDEX "vat_items_status_idx" ON "vat_items"("status");
