<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" %> 
<%@taglib uri="http://www.rapid-framework.org.cn/rapid" prefix="rapid" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<rapid:override name="import"><script src="${pageContext.request.contextPath}/static/js/register.js"></script></rapid:override>
<rapid:override name="body"> 
	<div class="register_con">
		<div class="l_con fl">
			<a class="reg_logo"><img src="${pageContext.request.contextPath}/static/images/logo02.png"></a>
			<div class="reg_slogan">足不出户  ·  新鲜每一天</div>
			<div class="reg_banner"></div>
		</div>

		<div class="r_con fr">
			<div class="reg_title clearfix">
				<h1>用户注册</h1>
				<a href="${pageContext.request.contextPath}/user/login">登录</a>
			</div>
			<div class="reg_form clearfix">
				<form action="register_handle" method="post" >
				<ul>
					<li>
						<label>用户名:</label>
						<input type="text" name="user_name" id="user_name">
						<span class="error_tip">提示信息</span>
					</li>					
					<li>
						<label>密码:</label>
						<input type="password" name="pwd" id="pwd">
						<span class="error_tip">提示信息</span>
					</li>
					<li>
						<label>确认密码:</label>
						<input type="password" name="cpwd" id="cpwd">
						<span class="error_tip">提示信息</span>
					</li>
					<li>
						<label>邮箱:</label>
						<input type="text" name="email" id="email">
						<span class="error_tip">提示信息</span>
					</li>
					<li class="agreement">
						<input type="checkbox" name="allow" id="allow" checked="checked">
						<label>同意”天天生鲜用户使用协议“</label>
						<span class="error_tip2">提示信息</span>
					</li>
					<li class="reg_sub">
						<input type="submit" value="注 册" name="">
					</li>
				</ul>				
				</form>
			</div>

		</div>

	</div>
       </rapid:override> 
       <%@ include file="../basefoot.jsp" %> <!-- 顺序要最后引入 -->
