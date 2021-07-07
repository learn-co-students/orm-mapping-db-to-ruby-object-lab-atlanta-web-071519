class Student
  attr_accessor :name,:grade, :id
  #attr_writer :id

  def self.create_table
    
      sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students 
      (id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    drop = <<-SQL
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(drop)
  end
def save
  save = <<-SQL
  INSERT INTO students (name,grade)
  VALUES (?,?)
  SQL

  DB[:conn].execute(save,self.name,self.grade)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
end

def self.new_from_db(row)
  new_student = self.new
  
  new_student.id = row[0]
  new_student.name=row[1]
  new_student.grade = row[2]
  new_student

 
  # create a new Student object given a row from the database
end

def self.find_by_name(name)
  find = <<-SQL 
  SELECT * 
  FROM students 
  WHERE name = ?
  SQL

  DB[:conn].execute(find, name).map do |row|
    self.new_from_db(row)
  end.first
end

def self.all_students_in_grade_9
  find = <<-SQL
  SELECT * FROM students 
  WHERE grade = 9
  SQL

  DB[:conn].execute(find).map do |row|
    self.new_from_db(row)
  end
end

def self.students_below_12th_grade
  find = <<-SQL
  SELECT * FROM students 
  WHERE grade < 12
  SQL

  DB[:conn].execute(find).map do |row|
    self.new_from_db(row)
  end
end

def self.all 
  find = <<-SQL
  SELECT * FROM students 
  
  SQL

  DB[:conn].execute(find).map do |row|
    self.new_from_db(row)
  end
end

def self.first_X_students_in_grade_10(x)
  find = <<-SQL
  SELECT  * FROM students 
  WHERE grade = 10
  LIMIT ?
  SQL

  DB[:conn].execute(find,x).map do |row|
    self.new_from_db(row)
  end
end

def self.first_student_in_grade_10
  find = <<-SQL
  SELECT  * FROM students 
  WHERE grade = 10
  LIMIT 1
  SQL

  #DB[:conn].execute(find)#.map do |row|
    self.new_from_db(DB[:conn].execute(find)[0])
  
end
   
def self.all_students_in_grade_X(x)
  find = <<-SQL
  SELECT  * FROM students 
  WHERE grade = ?
  SQL

  DB[:conn].execute(find,x).map do |row|
    self.new_from_db(row)
  end
end

end