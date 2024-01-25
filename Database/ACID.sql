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

BEGIN;

INSERT into user_balance("name",balance) VALUES ('toantn',1000);
INSERT into user_balance("name",balance) VALUES ('toantn',1000);

COMMIT;

-- Consistency(Nhất quán)

BEGIN;

INSERT into user_balance("name",balance) VALUES ('toantn_1',1000);
INSERT into user_balance("name",balance) VALUES ('toantn_2',1000);

COMMIT;

select * from user_balance;

-- Isolation(Độc lập)

BEGIN;

update user_balance set balance = 2000 where id = 3;

rollback;

BEGIN;

select * from user_balance where id = 3;

COMMIT;

-- Durability(Bền vững)

BEGIN;

INSERT into user_balance("name",balance) VALUES ('toantn',1000);
INSERT into user_balance("name",balance) VALUES ('toantn',1000);

COMMIT;

-- Shut down server -> Thông tin đã được commit trong trans không bị mất