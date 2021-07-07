class Student
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL
    DB[:conn].execute sql
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute sql
  end

  def save
    sql = <<-SQL
    SELECT id FROM students WHERE name IS ?
    SQL
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
    @id = DB[:conn].execute(sql, self.name)[0][0]
  end

  def self.create(hash)
    s1 = Student.new(hash[:name], hash[:grade])
    s1.save
    s1
  end

end
