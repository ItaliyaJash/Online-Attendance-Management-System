package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Protects all pages from unauthenticated access and enforces
 * role-based routing. Also sets cache-control headers so browsers
 * do not show protected pages after logout.
 */
public class SessionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();

        // Allow public resources without authentication
        if (isPublicResource(uri, request.getContextPath())) {
            chain.doFilter(request, response);
            return;
        }

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sessionexpired");
            return;
        }

        // Set no-cache headers on every protected page
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma",        "no-cache");
        response.setDateHeader("Expires",   0);

        // Role-based access control
        String role = (String) session.getAttribute("role");
        if (uri.contains("/admin/")   && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (uri.contains("/teacher/") && !"teacher".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        if (uri.contains("/student/") && !"student".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicResource(String uri, String contextPath) {
        return uri.endsWith("login.jsp")
            || uri.endsWith("index.jsp")
            || uri.endsWith("error.jsp")
            || uri.equals(contextPath + "/")
            || uri.endsWith("/login")
            || uri.endsWith("/logout")
            || uri.contains("/css/")
            || uri.contains("/images/")
            || uri.contains("/js/");
    }

    @Override
    public void destroy() {}
}
