-- Create table
CREATE TABLE user_balance (
  id serial4 NOT NULL,
  "name" varchar(100) not null,
  balance int8 NOT NULL,
  created_date timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_date timestamptz NULL,
  CONSTRAINT user_balance_balance_check CHECK ((balance >= 0)),
  CONSTRAINT user_balance_pk PRIMARY KEY (id)
);

-- Atomicity(Nguyên tử)
-- Mọi thay đổi về mặt dữ liệu phải được thục hiện trọn vẹn khi transaction thực hiện thành công hoặc không có bất kì sự thay đổi nào về mặt dữ liệu nếu có xẩy ra sự cố.
BEGIN;

INSERT into user_balance("name",balance) VALUES ('toantn',1000);
INSERT into user_balance("name",balance) VALUES ('toantn',1000);

COMMIT;

-- Consistency(Nhất quán)
-- Sau khi một transaction kết thúc thì tất cả dữ liệu phải được nhất quán dù thành công hay thất bại.
BEGIN;

INSERT into user_balance("name",balance) VALUES ('toantn_1',1000);
INSERT into user_balance("name",balance) VALUES ('toantn_2',1000);

COMMIT;

select * from user_balance;

-- Isolation(Độc lập)
-- Các transaction khi đông thời thực thi trên hệ thống thì không có bất kì ảnh hưởng gì tời nhau.
BEGIN;

update user_balance set balance = 2000 where id = 3;

rollback;

BEGIN;

select * from user_balance where id = 3;

COMMIT;

-- Durability(Bền vững)
-- Sau khi một transaction thành công thì tác dụng mà nó tạo ra phải bền vững trong cơ sở dữ liệu cho dù hệ thống có xẩy ra lỗi.
BEGIN;

INSERT into user_balance("name",balance) VALUES ('toantn',1000);
INSERT into user_balance("name",balance) VALUES ('toantn',1000);

COMMIT;

-- Shut down server -> Thông tin đã được commit trong trans không bị mất