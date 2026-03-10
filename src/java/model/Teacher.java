package model;

public class Teacher {
    private int    teacherId;
    private String name;
    private String email;
    private String phone;
    private String department;
    private String username;
    private String password;

    public Teacher() {}

    public Teacher(int teacherId, String name, String email, String phone,
                   String department, String username, String password) {
        this.teacherId  = teacherId;
        this.name       = name;
        this.email      = email;
        this.phone      = phone;
        this.department = department;
        this.username   = username;
        this.password   = password;
    }

    public int    getTeacherId()              { return teacherId; }
    public void   setTeacherId(int id)        { this.teacherId = id; }
    public String getName()                   { return name; }
    public void   setName(String n)           { this.name = n; }
    public String getEmail()                  { return email; }
    public void   setEmail(String e)          { this.email = e; }
    public String getPhone()                  { return phone; }
    public void   setPhone(String p)          { this.phone = p; }
    public String getDepartment()             { return department; }
    public void   setDepartment(String d)     { this.department = d; }
    public String getUsername()               { return username; }
    public void   setUsername(String u)       { this.username = u; }
    public String getPassword()               { return password; }
    public void   setPassword(String p)       { this.password = p; }
}
