require 'pg'
require 'csv'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

db_connection do |conn|
  CSV.foreach('sales.csv', headers: true) do |row|
    employees = conn.exec(
      'SELECT emp_name FROM employee'
    )
    emp_comb = row[0].split("(")
    emp_name = emp_comb[0].strip
    emp_email = emp_comb[1].chomp(")")

    unless employees.any? { |emp| emp["emp_name"] == emp_name }
      conn.exec_params(
          'INSERT INTO employee (emp_name, emp_email) VALUES($1, $2)',
          [emp_name, emp_email]
      )
    end

    emp_id = conn.exec_params(
      'SELECT id FROM employee WHERE emp_name=$1', [emp_name]
    )

    customers = conn.exec(
      'SELECT cust_name FROM customer'
    )

    cust_comb = row[1].split("(")
    cust_name = cust_comb[0].strip
    cust_acct = cust_comb[1].chomp(")")

    unless customers.any? { |cust| cust["cust_name"] == cust_name }
      conn.exec_params(
          'INSERT INTO customer (cust_name, cust_acct) VALUES($1, $2)',
          [cust_name, cust_acct]
      )
    end

    cust_id = conn.exec_params(
      'SELECT id FROM customer WHERE cust_name=$1', [cust_name]
    )

    products = conn.exec(
      'SELECT product_name FROM product'
    )

    product_name = row[2]

    unless products.any? { |product| product["product_name"] == product_name }
      conn.exec_params(
          'INSERT INTO product (product_name) VALUES($1)',
          [product_name]
      )
    end

    product_id = conn.exec_params(
      'SELECT id FROM product WHERE product_name=$1', [product_name]
    )

    frequencies = conn.exec(
      'SELECT freq FROM frequency'
    )

    freq = row[-1]
    unless frequencies.any? { |f| f["freq"] == freq }
      conn.exec_params(
          'INSERT INTO frequency (freq) VALUES($1)',
          [freq]
      )
    end

    freq_id = conn.exec_params(
      'SELECT id FROM frequency WHERE freq=$1', [freq]
    )

    invoice_num = row[6]
    units = row[5]
    sales_date = row[3]
    sales_amt = row[4]

    conn.exec_params(
        'INSERT INTO invoice (invoice_num, units, sales_date, sales_amt, freq_id, emp_id, cust_id, product_id)
        VALUES($1, $2, $3, $4, $5, $6, $7, $8)',
        [invoice_num, units, sales_date, sales_amt, freq_id, emp_id, cust_id, product_id]
    )

  end
end
