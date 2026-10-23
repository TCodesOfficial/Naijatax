-- CreateTable
CREATE TABLE "forum_votes" (
    "id" TEXT NOT NULL,
    "topic_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "direction" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "forum_votes_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "forum_votes_user_id_created_at_idx" ON "forum_votes"("user_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "forum_votes_topic_id_user_id_key" ON "forum_votes"("topic_id", "user_id");

-- AddForeignKey
ALTER TABLE "forum_votes" ADD CONSTRAINT "forum_votes_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "forum_topics"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "forum_votes" ADD CONSTRAINT "forum_votes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
