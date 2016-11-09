DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS frequency;


CREATE TABLE employee (
  id SERIAL PRIMARY KEY,
  emp_name VARCHAR(100),
  emp_email VARCHAR(100),
  UNIQUE (emp_name, emp_email)
);

CREATE TABLE customer (
  id SERIAL PRIMARY KEY,
  cust_name VARCHAR(100),
  cust_acct VARCHAR(100),
  UNIQUE (cust_name, cust_acct)
);

CREATE TABLE product (
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(100),
  UNIQUE (product_name)
);

CREATE TABLE frequency (
  id SERIAL PRIMARY KEY,
  freq VARCHAR(100),
  UNIQUE (freq)
);
CREATE TABLE invoice (
  id SERIAL PRIMARY KEY,
  invoice_num INT,
  units INT,
  sales_date DATE,
  sales_amt DECIMAL,
  freq_id INT REFERENCES frequency(id),
  emp_id INT REFERENCES employee(id),
  cust_id INT REFERENCES customer(id),
  product_id INT REFERENCES product(id)
);
