-- // ***  partition ***
-- + Phân vùng ngang: Chia table theo các row - bản ghi.
-- + Phân vùng dọc: Chia table theo các column.


// Kiểm tra DB có hỗ trợ hay k với lệnh:
+ SHOW PLUGINS
+
SELECT
PLUGIN_NAME as Name,
    PLUGIN_VERSION as Version,
    PLUGIN_STATUS as Status
    FROM INFORMATION_SCHEMA.PLUGINS
    WHERE PLUGIN_TYPE='STORAGE ENGINE';


-- // Có 4 loại Partition 
-- + Range Partition
-- + List Partition
-- + Hash Partition
-- + Key Partition

-- // Note:
-- + Partition sẽ được bắt đầu từ index bằng 0
-- + Số Partition có thể chia tối đa là 8192 partition
-- + partion name không phân biệt hoa thường, chẳng hạn partitionNumber1 & PARTITIONNUMBER1 sẽ báo lỗi

DROP TABLE Persons;

-- Range Partition --
CREATE TABLE Persons (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name varchar(255) not null,
    age int,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_user VARCHAR(20) DEFAULT '9999',
    PRIMARY KEY (id, age);
)
PARTITION BY RANGE (age) (
	PARTITION p0 VALUES LESS THAN (1000), 
	PARTITION p1 VALUES LESS THAN (10000), 
	PARTITION p2 VALUES LESS THAN (50000),
	PARTITION p3 VALUES LESS THAN (100000),
	PARTITION p4 VALUES LESS THAN MAXVALUE
);
select * from Persons where age = 99000

-- List Partition --
CREATE TABLE Person2 (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name varchar(255) not null,
    month int not null,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_user VARCHAR(20) DEFAULT '9999',
    PRIMARY KEY (id, month)
)
PARTITION BY LIST (month) (
    PARTITION pX VALUES IN (1,2,3),
    PARTITION pH VALUES IN (4,5,6),
    PARTITION pT VALUES IN (7,8,9),
    PARTITION pD VALUES IN (10,11,12)
);

value thuộc 1 tập constant, nếu insert ngoài giá trị thì bị lỗi,
nên chọn những cái cố định như ngày , tháng.

SELECT * FROM Person2 WHERE month = 2;

SELECT * FROM Person2 WHERE name = 'chung_10000';

-- Hash Partition ---
CREATE TABLE Person3 (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(30),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_user VARCHAR(20) DEFAULT '9999',
    store_id INT,
    PRIMARY KEY (id, store_id)
)
PARTITION BY HASH(store_id)
PARTITIONS 10;

-- Không giống như Range và List, Hash Partition không cần define trước value để quyết định xem row insert sẽ đc assign vào partition nào một cách tự động
-- Hash Partition chỉ sử dụng trên 1 column.
-- nếu k định nghĩa số lượng partition. thì sẽ default là 1

-- Key Partition ---
-- Tương tự như Hash Partition thì Key Partition có thể sử dụng 0 hoặc n column để partition.
-- Trường hợp không truyền column để partition thì primary key hoặc unique key sẽ auto được chọn, k có primary key hay unique thì sẽ báo lỗi.
CREATE TABLE serverlogs4 (
    serverid INT NOT NULL, 
    logdata VARCHAR(30),
    created DATETIME NOT NULL,
    UNIQUE KEY (serverid)
)
PARTITION BY KEY()
PARTITIONS 10;

CREATE TABLE serverlogs5 (
    serverid INT NOT NULL, 
    logdata VARCHAR(30),
    created DATETIME NOT NULL,
    label VARCHAR(10) NOT NULL
)
PARTITION BY KEY(serverid, label, created)
PARTITIONS 10;

-- // TH search and ra 20 bộ key mà partition có 10 thì sẽ như nào. ???????
-- => TH partition key thì nó k có trên postgres và tên mysql nó sẽ là cả cụm key partion nên bình thường ít ai dùng.
-- // Vs Person2 thì TH mà search nhiều tháng lệch partition thì sẽ làm như nào để nhanh ??????
-- => Thì phải cân đối cách chia partition, ví dụ chia nhỏ hơn thành 12 tháng.Còn như hiện tại nếu search tháng 1 và tháng 4 vì vẫn tìm ở 2 vùng partition pX và pH