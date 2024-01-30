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

-- * Index scan
--Index only scan
-- Docs: Lấy dữ liệu bởi key:value với điều kiện là index mà không cần truy cập vào DB gốc 
explain select id from user_balance where id = 3

--Index scan
-- Docs: Lấy dữ liệu bởi key:value với điều kiện là index, cần truy cập vào DB gốc 
explain select * from user_balance where id = 3

-- Combining DB indexes for better

insert into grades (g,
name  ) 
select 
random()*100,
substring(md5(random()::text ),0,floor(random()*31)::int)
 from generate_series(0, 1000);

create index on grades(g);
create index on grades(name);

explain analyze select id from grades where g = 30; -- Quét chỉ mục của g

explain analyze select id from grades where name = '422c8d5';  -- Quét chỉ mục của name

explain analyze select id from grades where g = 30 limit 2; -- Có limit với số lượng nhỏ thì hệ thống không cần xây dựng bitmap 

explain analyze select id from grades where g = 30 and name = '422c8d5'; 
-- Nếu g trả về nhiều row có giá trị 30 và name trả về nhiều row có giá trị '422c8d5'=> Quét cả 2 chỉ mục g và name
-- Nếu row g > row name (kết quả câu query trên) => Quét theo chỉ mục của name rồi thực hiện filter
explain analyze select id from grades where g = 30 or name = '422c8d5';-- Quét trên 2 chỉ mục.

Drop index grades_g_indx, grades_name_idx;
create index on grades(g, name);

explain analyze select id from grades where g = 30; -- Index được xây dựng từ trái qua phải --> Postgres có thể quét các giá trị chỉ mục từ bên trái, nhưng không thể quét từ bên phải.

explain analyze select id from grades where name = '422c8d5'; -- Thực hiện quét song song vì không sử dụng chỉ mục

explain analyze select id from grades where g = 30 and name = '422c8d5'; -- Nhanh hơn chỉ mục riêng lẻ

explain analyze select id from grades where g = 30 or name = '422c8d5'; -- Không sử dụng chỉ mục.

create index on grades(name);

explain analyze select id from grades where g = 30 or name = '422c8d5'; -- Sử dụng 2 chỉ mục grades(g, name) và grades(name)

explain analyze select id from grades where name = '422c8d5'; -- Quét chỉ mục của name

explain analyze select id from grades where g = 30 and name = '422c8d5'; -- Sử dụng chỉ mục grades(g, name). Nhanh hơn chỉ mục riêng lẻ
