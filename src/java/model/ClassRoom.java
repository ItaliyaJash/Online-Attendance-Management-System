package model;

public class ClassRoom {
    private int    classId;
    private String className;
    private String department;
    private int    semester;

    public ClassRoom() {}

    public ClassRoom(int classId, String className, String department, int semester) {
        this.classId    = classId;
        this.className  = className;
        this.department = department;
        this.semester   = semester;
    }

    public int    getClassId()                { return classId; }
    public void   setClassId(int id)          { this.classId = id; }
    public String getClassName()              { return className; }
    public void   setClassName(String n)      { this.className = n; }
    public String getDepartment()             { return department; }
    public void   setDepartment(String d)     { this.department = d; }
    public int    getSemester()               { return semester; }
    public void   setSemester(int s)          { this.semester = s; }
}
