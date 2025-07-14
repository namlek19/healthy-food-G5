<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Healthy Food</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/header-user.css"> 
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>
    <body>
        <jsp:include page="includes/header.jsp" />

        <!--        <div class="search-bar">
                    <form action="search">
                        <input type="text" placeholder="Searching for food..." required />        
                    </form>
                </div>-->

        <section class="bmi-section">
            <div class="row bmi-background m-0 justify-content-center">
                <div class="col-md-1"></div>

                <div class="col-md-6 d-flex align-items-center">
                    <div class="bmi-form-box w-100 p-4 shadow rounded">
                        <h4 class="text-success mb-4 text-center">TÍNH CHỈ SỐ BMI CỦA BẠN NGAY NÀO</h4>
                        <form action="bmi" method="post">
                            <div class="row">
                                <!-- Nhập liệu -->
                                <div class="col-md-6 pe-md-3">
                                    <small class="text-muted">*Chuẩn nhất khi áp dụng cho người từ 18 tuổi trở lên.</small>

                                    <div class="mb-3">
                                        <label for="height" class="form-label">Chiều cao (cm):</label>
                                        <input type="number" class="form-control no-spinner" step="0.1" name="height" min="80" max="250" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="weight" class="form-label">Cân nặng (kg):</label>
                                        <input type="number" class="form-control no-spinner" step="0.1" name="weight" min="20" max="300" required>
                                    </div>

                                    <button type="submit" class="btn btn-success w-100">Tính BMI</button>
                                </div>


                                <div class="col-md-6 ps-md-3 d-flex align-items-center">
                                    <div class="w-100">
                                        <%
                                            String bmiValue = (String) session.getAttribute("bmiValue");
                                            String bmiType = (String) session.getAttribute("bmiType");
                                            String error = (String) request.getAttribute("error");
                                        %>

                                        <% if (error != null) { %>
                                        <div class="alert alert-danger"><%= error %></div>
                                        <% } else if (bmiValue != null && bmiType != null) { 
                                            String bmiTypeVN = "";
                                            switch (bmiType) {
                                                case "Underweight":
                                                    bmiTypeVN = "Gầy";
                                                    break;
                                                case "Normal":
                                                    bmiTypeVN = "Bình thường";
                                                    break;
                                                case "Overweight":
                                                    bmiTypeVN = "Thừa cân";
                                                    break;
                                                case "Obese":
                                                    bmiTypeVN = "Béo phì";
                                                    break;
                                                default:
                                                    bmiTypeVN = bmiType;
                                            }
                                        %>
                                        <div class="alert alert-success">
                                            <p>BMI của bạn là: <strong><%= bmiValue %></strong></p>
                                            <p>Thuộc loại: <strong><%= bmiTypeVN %></strong></p>
                                        </div>
                                        <% } else { %>
                                        <div class="text-muted fst-italic">Kết quả BMI sẽ hiển thị tại đây.</div>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="col-md-5"></div>
            </div>
        </section> 

        <section class="hero-bmi-section">
            <div class="container">
                <div class="row align-items-center">

                    <div class="col-md-7 d-flex justify-content-center">
                        <div class="hero-text-box text-center">
                            <h1>COMBO CỦA HEALTHY MEAL</h1>
                            <p>Cùng thử ngay những combo phù hợp đặc biệt dành cho bạn theo chỉ số BMI nào.</p>
                            <a href="menucus?bmi=${sessionScope.bmiType}" class="cta-button btn btn-success">Thử ngay</a>
                        </div>
                    </div>

                    <div class="col-md-1"></div>

                    <div class="col-md-4 text-center">
                        <img src="assets/images/anhmoipro.png" alt="Ảnh minh hoạ"
                             class="img-fluid" style="max-height: 400px;">
                    </div>
                </div>
            </div>
        </section>

        <h3 class="text-success text-center">Món ăn mới nhất</h3>
        <div class="row">
            <c:forEach var="p" items="${newestProducts}">
                <div class="col-md-3 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${p.imageURL}" class="card-img-top custom-size" alt="${p.name}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title text-truncate">${p.name}</h5>
                            <p class="card-text">Calories: ${p.calories} kcal</p>
                            <p class="fw-bold text-success">
                                <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> VNĐ
                            </p>
                            <a href="productdetail?id=${p.productID}" class="btn btn-outline-success mt-auto w-100">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>                            
        <h3 class="text-success text-center ">Combo mới nhất</h3>
        <div class="row">
            <c:if test="${empty newestMenus}">
                <div class="alert alert-warning">Không có combo nào (status 3 hoặc 4) được tìm thấy.</div>
            </c:if>
            <c:forEach var="menu" items="${newestMenus}">
                <div class="col-md-3 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${menu.imageURL}" class="card-img-top menu-card-img" alt="${menu.menuName}">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title text-success text-truncate">${menu.menuName}</h5>
                            <p class="card-text text-truncate">${menu.description}</p>
                            <p class="fw-bold text-success">
                                Tổng giá: <fmt:formatNumber value="${menu.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                            </p>
                            <a href="menudetail?id=${menu.menuID}" class="btn btn-outline-success mt-auto w-100">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>                           

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
