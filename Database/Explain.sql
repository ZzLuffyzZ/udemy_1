--explain explained

-- make sure to run the container with at least 1gb shared memory
-- docker run --name pg —shm-size=1g -e POSTGRES_PASSWORD=postgres —name pg postgres



create table grades (
id serial primary key, 
 g int,
 name text 
); 


insert into grades (g,
name  ) 
select 
random()*100,
substring(md5(random()::text ),0,floor(random()*31)::int)
 from generate_series(0, 500);

explain analyze select id,g from grades where g > 80 and g < 95 order by g;

--  (cost=0.00..11943.34 rows=2 width=4)
-- cost:
-- + 0.00: Thời gian để lấy dữ liệu row đầu tiên.
-- + 11943.34: Thời gian để lấy toàn bộ dữ liệu
-- rows: Số lượng row trả về dự tính.
-- with: độ rộng của 1 row.