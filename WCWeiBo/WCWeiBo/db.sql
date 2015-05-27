-- 创建数据表
CREATE TABLE IF NOT EXISTS "T_Status" (
"statusId" INTEGER NOT NULL,
"status" TEXT NOT NULL,
"userId" INTEGER NOT NULL,
PRIMARY KEY("statusId")
);

-- 如果有跟多的表可以继续粘贴 SQL..