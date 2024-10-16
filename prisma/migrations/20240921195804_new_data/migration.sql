/*
  Warnings:

  - The values [Sunday,Monday,Tuesday,Wednesday,Thursday] on the enum `Day` will be removed. If these variants are still used in the database, this will fail.
  - The values [Male,Female] on the enum `UserSex` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `endtime` on the `Lesson` table. All the data in the column will be lost.
  - You are about to drop the column `starttime` on the `Lesson` table. All the data in the column will be lost.
  - Added the required column `endTime` to the `Lesson` table without a default value. This is not possible if the table is not empty.
  - Added the required column `startTime` to the `Lesson` table without a default value. This is not possible if the table is not empty.
  - Added the required column `birthday` to the `Student` table without a default value. This is not possible if the table is not empty.
  - Added the required column `birthday` to the `Teacher` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Day_new" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY');
ALTER TABLE "Lesson" ALTER COLUMN "day" TYPE "Day_new" USING ("day"::text::"Day_new");
ALTER TYPE "Day" RENAME TO "Day_old";
ALTER TYPE "Day_new" RENAME TO "Day";
DROP TYPE "Day_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "UserSex_new" AS ENUM ('MALE', 'FEMALE');
ALTER TABLE "Student" ALTER COLUMN "sex" TYPE "UserSex_new" USING ("sex"::text::"UserSex_new");
ALTER TABLE "Teacher" ALTER COLUMN "sex" TYPE "UserSex_new" USING ("sex"::text::"UserSex_new");
ALTER TYPE "UserSex" RENAME TO "UserSex_old";
ALTER TYPE "UserSex_new" RENAME TO "UserSex";
DROP TYPE "UserSex_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "Class" DROP CONSTRAINT "Class_supervisorId_fkey";

-- AlterTable
ALTER TABLE "Class" ALTER COLUMN "supervisorId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Lesson" DROP COLUMN "endtime",
DROP COLUMN "starttime",
ADD COLUMN     "endTime" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "startTime" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Student" ADD COLUMN     "birthday" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "phone" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Teacher" ADD COLUMN     "birthday" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "phone" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Class" ADD CONSTRAINT "Class_supervisorId_fkey" FOREIGN KEY ("supervisorId") REFERENCES "Teacher"("id") ON DELETE SET NULL ON UPDATE CASCADE;
