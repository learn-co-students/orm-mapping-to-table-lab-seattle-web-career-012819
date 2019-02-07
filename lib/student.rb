class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name,:grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    sql = <<-SQL
    INSERT INTO #{self.class.name.downcase + 's'}(name, grade)
    VALUES ("#{self.name}", "#{self.grade}");
    SQL

    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT id FROM students ORDER BY id")[0].last
    self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS #{self.name.downcase + 's'}(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS #{self.name.downcase + 's'};
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(attributes = {})
    new = self.new(attributes[:name], attributes[:grade])
    new.save
  end

end
