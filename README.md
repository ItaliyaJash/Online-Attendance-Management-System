# 🎓 Online Attendance Management System (OAMS)

<div align="center">

![Java](https://img.shields.io/badge/Java-17+-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![Jakarta EE](https://img.shields.io/badge/Jakarta_EE-Servlet_6.0-blue?style=for-the-badge)
![JSP](https://img.shields.io/badge/JSP-JavaServer_Pages-blueviolet?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache_Tomcat-11.x-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![MVC](https://img.shields.io/badge/Pattern-MVC-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A role-based web application for digitizing student attendance management**
*Built with Java Servlet + JSP + MySQL following MVC Architecture*

[Features](#-features) • [Architecture](#-architecture--working-principle) • [Tech Stack](#-technology-stack) • [Concepts](#-core-java--web-concepts) • [Setup](#-setup--installation) • [Database](#-database-schema) • [URLs](#-url-reference)

</div>

---

## 📖 About the Project

The **Online Attendance Management System (OAMS)** is a full-stack Java web application developed as an **End-Semester Project** for *Advanced Java Technology (Semester IV)* at **Dharmsinh Desai University, Nadiad**.

It replaces traditional paper-based attendance with a fast, secure, centralized digital platform that supports **three user roles** — Admin, Teacher, and Student — each with dedicated dashboards and role-specific features.

> 🔗 **Repository:** https://github.com/ItaliyaJash/Online-Attendance-Management-System

---

## ✨ Features

### 👨‍💼 Admin Module
- Secure login with session management
- Add and view Teachers (name, username, email, phone, department)
- Add and view Students (roll number, class, department, semester)
- Add Classes (CS-A, CS-B, IT-A, IT-B) and assign Subjects to Teachers
- Real-time dashboard showing total counts of all entities

### 👩‍🏫 Teacher Module
- Dashboard with assigned subjects list and quick action cards
- **Take Attendance** — select class, subject, date → dynamic student list with radio buttons
- **Mark All Present / Mark All Absent** — bulk action buttons
- **View Attendance Records** — filter by subject and date with Present/Absent badges
- **Inline Update** — correct attendance without navigating away from the page
- **Generate Reports** — subject-wise % report with colour-coded progress bars (green/orange/red)

### 👨‍🎓 Student Module
- Overall attendance percentage with total/present/absent stat cards
- **Subject-wise breakdown** with progress bars and OK/Low status badges
- **Day-wise drill-down** — attendance history per subject by date
- **Low attendance warning** — alert when below 75% threshold
- **Profile page** — personal details and class information

### 🔐 Security Features
- `SessionFilter` intercepts ALL requests and validates login state
- `Cache-Control` headers prevent back-button access after logout
- `PreparedStatement` prevents SQL injection on every database query
- **Session timeout** after 30 minutes of inactivity
- Role-based URL protection: `/admin/*`, `/teacher/*`, `/student/*`

---

## 🏗 Architecture & Working Principle

### MVC (Model-View-Controller) Pattern

OAMS strictly follows the **MVC design pattern** which separates the application into three independent layers:

```
Browser Request
      │
      ▼
┌─────────────────────────────────────────────────────────────┐
│                   CONTROLLER LAYER                          │
│             Jakarta Servlet (HttpServlet)                   │
│                                                             │
│  - Receives HTTP GET / POST requests from the browser       │
│  - Validates session and checks user role                   │
│  - Calls DAO methods to fetch or save data                  │
│  - Sets data as request attributes                          │
│  - Forwards to JSP (for display) or sendRedirect (after     │
│    form submission)                                         │
└────────────────────────┬────────────────────────────────────┘
                         │
           ┌─────────────┴──────────────┐
           ▼                            ▼
┌────────────────────┐       ┌─────────────────────────┐
│    MODEL LAYER     │       │       VIEW LAYER         │
│                    │       │                          │
│  Java Beans        │       │   JSP Pages (.jsp)       │
│  DAO Classes       │       │                          │
│  MySQL Database    │       │  - Renders HTML to       │
│                    │       │    browser               │
│  Pure Java objects │       │  - Reads request         │
│  No HTTP knowledge │       │    attributes set by     │
│  No JSP knowledge  │       │    the servlet           │
│                    │       │  - Contains NO business  │
│                    │       │    logic                 │
└────────────────────┘       └─────────────────────────┘
```

### Complete Request-Response Lifecycle

Every user action in OAMS follows this exact sequence:

```
STEP 1: USER ACTION
        Browser sends HTTP request
        e.g. POST /login, GET /admin/dashboard, GET /teacher/takeAttendance
              │
              ▼
STEP 2: SessionFilter (intercepts ALL requests via /* mapping)
        ├─ Is this a public path? (/login, /index.jsp) → allow through
        ├─ Is there a valid session with role set?
        │   ├─ YES → set Cache-Control headers → chain.doFilter() → continue
        │   └─ NO  → response.sendRedirect("/login.jsp?error=unauthorized") → STOP
              │
              ▼
STEP 3: Servlet receives the request
        ├─ Reads parameters: request.getParameter("username")
        ├─ Reads session:    session.getAttribute("userId")
        ├─ Calls DAO:        new AttendanceDAO().getByStudent(id)
        ├─ Sets attributes:  request.setAttribute("records", list)
        └─ Forwards to JSP:  RequestDispatcher.forward(req, res)
              │
              ▼
STEP 4: DAO queries MySQL
        ├─ Gets connection:  DBConnection.getConnection()
        ├─ Creates query:    PreparedStatement ps = conn.prepareStatement(sql)
        ├─ Sets parameters:  ps.setInt(1, studentId)
        ├─ Executes:         ResultSet rs = ps.executeQuery()
        ├─ Maps to objects:  new Attendance(rs.getInt(...), ...)
        └─ Returns list:     return attendanceList
              │
              ▼
STEP 5: JSP renders the page
        ├─ Retrieves data:  request.getAttribute("records")
        ├─ Iterates list:   <% for (Attendance a : records) { %>
        ├─ Renders HTML:    <%= a.getStatus() %>
        └─ Sends response to browser
              │
              ▼
STEP 6: Browser displays final HTML page to user
```

### sendRedirect vs forward

| Method | When Used | URL Changes? | New Request? |
|---|---|---|---|
| `response.sendRedirect(url)` | After login, logout, POST form | ✅ Yes | ✅ Yes |
| `dispatcher.forward(req, res)` | Sending data to JSP for display | ❌ No | ❌ No |

**Rule in OAMS:** POST form submissions always use `sendRedirect` (PRG pattern to prevent resubmission on refresh). GET display operations always use `forward` to JSP.

---

## 💡 Core Java & Web Concepts

### 1. Jakarta Servlet API

Servlets are Java classes that handle HTTP requests. Each servlet extends `HttpServlet` and overrides `doGet()` and/or `doPost()`:

```java
// URL: /login  →  mapped in web.xml
public class LoginServlet extends HttpServlet {

    // GET /login → show login form
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // POST /login → validate credentials and create session
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role     = request.getParameter("role"); // or detect from DB

        UserDAO dao = new UserDAO();
        Object user = dao.validateLogin(username, password, "admin");

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("role",   "admin");
            session.setAttribute("userId", admin.getAdminId());
            session.setAttribute("name",   admin.getFullName());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
```

### 2. HttpSession — User State Management

HTTP is a **stateless protocol** — the server doesn't remember who you are between requests. `HttpSession` solves this by storing user data server-side:

```java
// CREATE session on login
HttpSession session = request.getSession();           // creates new session
session.setAttribute("role",   "teacher");
session.setAttribute("userId", teacher.getTeacherId());
session.setMaxInactiveInterval(30 * 60);              // 30 min timeout

// VALIDATE session on every protected page
HttpSession session = request.getSession(false);      // false = don't create new!
if (session == null || !"teacher".equals(session.getAttribute("role"))) {
    response.sendRedirect("../login.jsp?error=unauthorized");
    return; // MUST return to stop execution
}
int teacherId = (int) session.getAttribute("userId"); // read data

// DESTROY session on logout
HttpSession session = request.getSession(false);
if (session != null) session.invalidate();
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.sendRedirect(request.getContextPath() + "/login.jsp?message=loggedout");
```

### 3. SessionFilter — Centralized Route Protection

Instead of copy-pasting session validation in every servlet, OAMS uses a `Filter` that automatically intercepts ALL requests via `/*` mapping:

```java
@WebFilter("/*")
public class SessionFilter implements Filter {

    // Paths accessible without login
    private static final List<String> PUBLIC_PATHS =
        Arrays.asList("/login", "/login.jsp", "/index.jsp", "/error.jsp");

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpReq = (HttpServletRequest)  req;
        HttpServletResponse httpRes = (HttpServletResponse) res;

        String uri = httpReq.getRequestURI()
                            .substring(httpReq.getContextPath().length());

        HttpSession session  = httpReq.getSession(false);
        boolean     loggedIn = (session != null
                                && session.getAttribute("role") != null);

        if (loggedIn || isPublicPath(uri)) {
            // Prevent browser from caching protected pages
            httpRes.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpRes.setHeader("Pragma",        "no-cache");
            httpRes.setDateHeader("Expires",    0);
            chain.doFilter(req, res);  // allow through
        } else {
            // Not logged in → redirect to login
            httpRes.sendRedirect(httpReq.getContextPath()
                + "/login.jsp?error=unauthorized");
        }
    }

    private boolean isPublicPath(String uri) {
        return PUBLIC_PATHS.stream().anyMatch(uri::startsWith)
            || uri.startsWith("/css/");
    }
}
```

### 4. JDBC & DAO Pattern

**JDBC (Java Database Connectivity)** is the Java API for connecting to relational databases. OAMS uses the **DAO (Data Access Object)** pattern to isolate all database logic:

```java
// DBConnection.java — Connection factory
public class DBConnection {
    private static final String URL  = "jdbc:mysql://localhost:3306/attendance_system";
    private static final String USER = "root";
    private static final String PASS = "your_password";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}

// AttendanceDAO.java — Example DAO with PreparedStatement
public List<Attendance> getByStudentId(int studentId) throws Exception {
    List<Attendance> list = new ArrayList<>();

    // ? is a placeholder — prevents SQL injection
    String sql = "SELECT * FROM attendance WHERE student_id = ? ORDER BY date DESC";

    try (Connection    conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, studentId);  // safely binds the value
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Attendance a = new Attendance();
            a.setAttendanceId(rs.getInt("attendance_id"));
            a.setStudentId   (rs.getInt("student_id"));
            a.setSubjectId   (rs.getInt("subject_id"));
            a.setTeacherId   (rs.getInt("teacher_id"));
            a.setDate        (rs.getString("date"));
            a.setStatus      (rs.getString("status"));
            list.add(a);
        }
    } // try-with-resources auto-closes Connection, PreparedStatement, ResultSet

    return list;
}
```

### 5. JavaBeans (Model Classes)

All entity classes follow the **JavaBean convention** — private fields, public getters/setters, no-arg constructor. This makes them usable in JSP via EL expressions:

```java
public class Student {
    // Private fields — encapsulation
    private int    studentId;
    private String rollNo;
    private String name;
    private String email;
    private String department;
    private int    semester;
    private int    classId;
    private String username;
    private String password;

    // No-arg constructor (required by JavaBean spec)
    public Student() {}

    // Parameterized constructor (for convenience)
    public Student(int studentId, String rollNo, String name) {
        this.studentId = studentId;
        this.rollNo    = rollNo;
        this.name      = name;
    }

    // Getters and Setters for every field
    public int    getStudentId()           { return studentId; }
    public void   setStudentId(int id)     { this.studentId = id; }
    public String getName()                { return name; }
    public void   setName(String name)     { this.name = name; }
    // ... all other getters and setters
}
```

### 6. JSP (JavaServer Pages)

JSP is Java's server-side templating technology. Servlets set data as request attributes; JSP reads and renders them as HTML:

```jsp
<%-- Servlet sets: request.setAttribute("subjectSummary", summary) --%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    // Cast the object back from Object to the correct type
    List<Map<String,String>> summary =
        (List<Map<String,String>>) request.getAttribute("subjectSummary");
%>

<table class="data-table">
    <thead>
        <tr><th>Subject</th><th>Total</th><th>Present</th><th>%</th><th>Status</th></tr>
    </thead>
    <tbody>
    <%
        for (Map<String,String> row : summary) {
            double pct = Double.parseDouble(row.get("percentage"));
            String badgeClass = "OK".equals(row.get("status")) ? "badge-ok" : "badge-low";
    %>
        <tr>
            <td><%= row.get("subjectName") %></td>
            <td><%= row.get("total") %></td>
            <td><%= row.get("present") %></td>
            <td><strong><%= row.get("percentage") %>%</strong></td>
            <td>
                <span class="<%= badgeClass %>">
                    <%= "OK".equals(row.get("status")) ? "✓ OK" : "⚠ Low" %>
                </span>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>
```

### 7. web.xml — Deployment Descriptor

`web.xml` is the configuration file that maps URLs to Servlets and registers Filters:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee" version="6.0">

    <!-- Register SessionFilter for ALL requests -->
    <filter>
        <filter-name>SessionFilter</filter-name>
        <filter-class>servlet.SessionFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>SessionFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <!-- Map URL pattern to Servlet class -->
    <servlet>
        <servlet-name>LoginServlet</servlet-name>
        <servlet-class>servlet.LoginServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>LoginServlet</servlet-name>
        <url-pattern>/login</url-pattern>
    </servlet-mapping>

    <!-- ... 17 more servlet mappings ... -->

    <!-- Session timeout: 30 minutes -->
    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>

</web-app>
```

---

## 🛠 Technology Stack

| Layer | Technology | Version | Purpose |
|---|---|---|---|
| **Frontend** | HTML5 + CSS3 | — | Page structure and custom styling |
| **View** | JSP (JavaServer Pages) | — | Dynamic HTML generation from Java |
| **Controller** | Jakarta Servlet | 6.0 | HTTP request + response handling |
| **Model** | Java Beans | — | Entity data representation |
| **Database Access** | JDBC | — | Java-to-MySQL connectivity |
| **Query Safety** | PreparedStatement | — | SQL injection prevention |
| **Database** | MySQL | 8.0 | Relational data storage |
| **Server** | Apache Tomcat | 11.x | Servlet container / web server |
| **Architecture** | MVC Pattern | — | Separation of concerns |
| **Session** | HttpSession API | — | User state management |
| **Security** | SessionFilter | — | Centralized route protection |
| **Language** | Java | 17+ | Core programming language |
| **IDE** | Apache NetBeans | Latest | Project development |
| **VCS** | Git + GitHub | — | Version control |

> **Why Jakarta EE over Java EE?**
> Oracle transferred Java EE to the Eclipse Foundation in 2017 → renamed to **Jakarta EE**.
> Tomcat 10+ implements Jakarta EE 9+ → uses `jakarta.*` namespace.
> Tomcat 9 and older → uses `javax.*` namespace.

---

## 📁 Project Structure

```
Online_Attendance_Management_System/
│
├── src/
│   ├── model/                           ← JavaBean entity classes
│   │   ├── User.java                    ← Base user (id, username, password, role)
│   │   ├── Student.java                 ← Student entity
│   │   ├── Teacher.java                 ← Teacher entity
│   │   ├── Subject.java                 ← Subject entity
│   │   ├── ClassRoom.java               ← Class entity (CS-A, IT-B etc.)
│   │   └── Attendance.java              ← Attendance record entity
│   │
│   ├── dao/                             ← Data Access Object layer
│   │   ├── DBConnection.java            ← ⚠ EDIT YOUR DB PASSWORD HERE
│   │   ├── UserDAO.java                 ← Login validation for all 3 roles
│   │   ├── StudentDAO.java              ← Student CRUD operations
│   │   ├── TeacherDAO.java              ← Teacher CRUD operations
│   │   ├── SubjectDAO.java              ← Subject queries + by-teacher filter
│   │   ├── ClassDAO.java                ← Class queries
│   │   └── AttendanceDAO.java           ← Mark / view / update / report
│   │
│   └── servlet/                         ← Controller layer (18 servlets)
│       ├── SessionFilter.java           ← Protects ALL routes (/* mapping)
│       ├── LoginServlet.java            ← /login  (GET + POST)
│       ├── LogoutServlet.java           ← /logout
│       ├── AdminDashboardServlet.java   ← /admin/dashboard
│       ├── AddTeacherServlet.java       ← /admin/addTeacher
│       ├── ViewTeachersServlet.java     ← /admin/viewTeachers
│       ├── AddStudentServlet.java       ← /admin/addStudent
│       ├── ViewStudentsServlet.java     ← /admin/viewStudents
│       ├── AddClassServlet.java         ← /admin/addClass
│       ├── AddSubjectServlet.java       ← /admin/addSubject
│       ├── TeacherDashboardServlet.java ← /teacher/dashboard
│       ├── TakeAttendanceServlet.java   ← /teacher/takeAttendance
│       ├── ViewAttendanceServlet.java   ← /teacher/viewAttendance
│       ├── UpdateAttendanceServlet.java ← /teacher/updateAttendance
│       ├── ReportServlet.java           ← /report
│       ├── StudentDashboardServlet.java ← /student/dashboard
│       ├── ViewMyAttendanceServlet.java ← /student/viewMyAttendance
│       └── StudentProfileServlet.java   ← /student/profile
│
├── WebContent/
│   ├── index.jsp                        ← Home / Landing page
│   ├── login.jsp                        ← Login form (two-panel design)
│   ├── error.jsp                        ← Error page
│   ├── css/
│   │   └── style.css                    ← Shared stylesheet (navy theme)
│   ├── admin/                           ← 7 admin JSP pages
│   ├── teacher/                         ← 4 teacher JSP pages
│   ├── student/                         ← 3 student JSP pages
│   └── WEB-INF/
│       └── web.xml                      ← Servlet mappings + filter config
│
├── database/
│   └── attendance_system.sql            ← Full schema + 675+ sample records
│
└── README.md
```

**Total: 6 Model + 7 DAO + 18 Servlet + 14 JSP + 1 CSS + 1 web.xml = 48 files**

---

## 🗄 Database Schema

### Entity-Relationship Overview

```
admin          teacher           class
(1 admin)      (6 teachers)      (4 classes)
    │               │                │
    │               │ 1              │ 1
    │               ▼                ▼
    │           subject ◄──── N   student
    │           (13 subjects)      (35 students)
    │               │                │
    │               │ 1              │ 1
    │               └────────┬───────┘
    │                        │ N
    │                        ▼
    │                   attendance       ← Central Bridge Table
    │                   (675+ records)
    │
    └── manages all entities above (CRUD via admin dashboard)
```

### Table Details

| Table | Primary Key | Foreign Keys | Records |
|---|---|---|---|
| `admin` | `admin_id` | — | 1 |
| `teacher` | `teacher_id` | — | 6 |
| `class` | `class_id` | — | 4 |
| `subject` | `subject_id` | `teacher_id → teacher` | 13 |
| `student` | `student_id` | `class_id → class` | 35 |
| `attendance` | `attendance_id` | `student_id, subject_id, teacher_id` | 675+ |

---

## ⚙ Setup & Installation

### Prerequisites

| Software | Version | Download |
|---|---|---|
| JDK | 17+ | [oracle.com](https://www.oracle.com/java/technologies/downloads/) |
| Apache NetBeans | Latest | [netbeans.apache.org](https://netbeans.apache.org/) |
| Apache Tomcat | **11.x** ⚠ | [tomcat.apache.org](https://tomcat.apache.org/) |
| MySQL Server | 8.0 | [dev.mysql.com](https://dev.mysql.com/downloads/mysql/) |
| MySQL Workbench | Latest | [dev.mysql.com](https://dev.mysql.com/downloads/workbench/) |
| MySQL JDBC Connector | 8.x | [dev.mysql.com](https://dev.mysql.com/downloads/connector/j/) |

> ⚠️ **Must use Tomcat 11.x** — uses `jakarta.*` imports (not `javax.*`)

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/ItaliyaJash/Online-Attendance-Management-System.git
cd Online-Attendance-Management-System
```

### Step 2 — Set Up the Database

Open **MySQL Workbench** → Run the SQL file:

```sql
SOURCE /path/to/database/attendance_system.sql;

-- Verify data loaded correctly
USE attendance_system;
SELECT COUNT(*) FROM student;     -- Expected: 35
SELECT COUNT(*) FROM teacher;     -- Expected: 6
SELECT COUNT(*) FROM attendance;  -- Expected: 675+
```

### Step 3 — Configure Database Password

Edit `src/dao/DBConnection.java`:
```java
private static final String PASS = "your_mysql_password"; // ← Change this
```

### Step 4 — Add MySQL JDBC Driver

1. Download `mysql-connector-j-8.x.x.jar` from MySQL official site
2. Copy the JAR to `WebContent/WEB-INF/lib/`
3. In NetBeans: Right-click project → Properties → Libraries → Add JAR/Folder

### Step 5 — Configure Tomcat

```
NetBeans: Tools → Servers → Add Server
→ Apache Tomcat 11.x → Browse installation folder → Finish
```

### Step 6 — Run the Project

```
Right-click project → Run (F6)
```

Open browser: **`http://localhost:8080/Online_Attendance_Management_System/`**

---

## 🔑 Default Login Credentials

| Role | Username | Password |
|---|---|---|
| 👨‍💼 Admin | `admin` | `admin123` |
| 👩‍🏫 Teacher | `teacher1` | `teacher123` |
| 👩‍🏫 Teacher | `teacher2` | `teacher123` |
| 👨‍🎓 Student | `student1` | `student123` |

---

## 🌐 URL Reference

| URL | Method | Description |
|---|---|---|
| `/` | GET | Home / Landing page |
| `/login.jsp` | GET | Login form |
| `/login` | POST | Process login → redirect by role |
| `/logout` | GET | Invalidate session → redirect to login |
| `/admin/dashboard` | GET | Admin dashboard with entity counts |
| `/admin/addTeacher` | GET/POST | Add teacher form and save |
| `/admin/viewTeachers` | GET | View all teachers list |
| `/admin/addStudent` | GET/POST | Add student form and save |
| `/admin/viewStudents` | GET | View all students list |
| `/admin/addClass` | GET/POST | Add class |
| `/admin/addSubject` | GET/POST | Add subject |
| `/teacher/dashboard` | GET | Teacher dashboard + assigned subjects |
| `/teacher/takeAttendance` | GET/POST | Mark attendance for a class |
| `/teacher/viewAttendance` | GET | View records by subject + date |
| `/teacher/updateAttendance` | POST | Update single attendance record |
| `/report` | GET | Generate % report by subject + class |
| `/student/dashboard` | GET | Student dashboard + overall % |
| `/student/viewMyAttendance` | GET | Subject-wise + day-wise attendance |
| `/student/profile` | GET | Student profile page |

---
---

## 📊 Project Statistics

| Metric | Value |
|---|---|
| Total Java files | 48 |
| Lines of code | ~4,500 |
| Database tables | 6 |
| Servlets | 18 |
| JSP pages | 14 |
| Model classes | 6 |
| DAO classes | 7 |
| User roles | 3 |
| Sample students | 35 |
| Sample attendance records | 675+ |
| Supported browsers | All modern browsers |

---

## 🔧 Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `ClassNotFoundException` MySQL driver | JAR not in WEB-INF/lib | Copy `mysql-connector-j.jar` to `WebContent/WEB-INF/lib/` |
| `Access denied for user 'root'` | Wrong password | Update `PASS` in `DBConnection.java` |
| `Communications link failure` | MySQL not running | Start MySQL service from Services panel |
| `404 /login` not found | Wrong form action | Use `action="login"` (no leading slash) in login form |
| `javax.servlet cannot be resolved` | Using Tomcat 9.x | Switch to **Tomcat 11.x** |
| `Table 'attendance_system.xxx' doesn't exist` | SQL not executed | Run `attendance_system.sql` again in MySQL Workbench |
| `404 /logout` error | Hardcoded path | Use `request.getContextPath() + "/logout"` in navbar |
| Back button works after logout | Missing cache headers | Verify `SessionFilter` is in `web.xml` with `/*` mapping |
| `Duplicate local variable` JSP error | Variable declared twice | Declare once before loop, reuse in summary section |
| HTTP 500 Internal Server Error | JSP compile error or DB issue | Check NetBeans output panel → Tomcat logs |

---

## 🔮 Future Enhancements

- [ ] Email alerts when attendance drops below 75%
- [ ] Export attendance reports as PDF or Excel
- [ ] Android / iOS companion mobile app
- [ ] QR code-based contactless attendance marking
- [ ] BCrypt password hashing for enhanced security
- [ ] Interactive attendance trend charts and graphs
- [ ] Cloud deployment (AWS / Azure / Google Cloud)
- [ ] JSTL instead of JSP scriptlets for cleaner views
- [ ] Biometric / face recognition integration
- [ ] SMS notifications to parents/guardians

---

## 👨‍💻 Author

**Jash Italiya**
B.Tech Information Technology

[![GitHub](https://img.shields.io/badge/GitHub-ItaliyaJash-black?style=for-the-badge&logo=github)](https://github.com/ItaliyaJash)

---

## 📄 License

This project is developed for **educational purposes** as part of the B.Tech IT curriculum at DDU Nadiad. Feel free to use it as reference for learning Java web development.

---

<div align="center">

**Built with ❤️ using Java Servlet + JSP + MySQL**

*Advanced Java Technology*

⭐ Star this repository if you found it helpful!

</div>
