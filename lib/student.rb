require_relative "../config/environment.rb"

class Student

attr_accessor :name, :id, :grade
 def initialize(id = nil, name , grade)
  @name = name
  @id = id
  @grade = grade
 end

  def self.create(name,grade)
  newstudent = Student.new(name,grade)
  newstudent.save
  end


  def self.new_from_db(array)

   Student.new(array[0],array[1],array[2])

  end

  def self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY,name TEXT, grade INTEGER)
  SQL
  DB[:conn].execute(sql)
  end

  def self.drop_table
   sql = "DROP TABLE IF EXISTS students"
   DB[:conn].execute(sql)


  end

  def save

  if self.id

    self.update

  else
  sql = <<-SQL

   INSERT INTO students (name,grade)
   VALUES (?,?)
  SQL
   DB[:conn].execute(sql,self.name,self.grade)

  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students") [0][0]
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

end 
 end

  def self.find_by_name(name)

  sql = "SELECT * FROM students WHERE students.name = ?"

  result = DB[:conn].execute(sql,name)[0]
  Student.new(result[0],result[1],result[2])

  end

 def update

   sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
   DB[:conn].execute(sql,self.name,self.grade,self.id)

 end
end
