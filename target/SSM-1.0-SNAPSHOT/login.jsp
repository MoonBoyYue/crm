<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String basePath = request.getScheme() + "://" + request.getServerName()
			+":"+request.getServerPort()+request.getContextPath()+"/";
%>

<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" id="loginName" name="username" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPassword" name="password" type="password" placeholder="密码">
						7天免登录<input class="checkbox" id="sevenDayNoLogin" type="checkbox" >
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<span id="msg" style="color: red;">${param.msg}</span>
					</div>
					<%--按钮写在表单中默认就是提交form表单，将type的submit换成button表示为一个普通的按钮--%>
					<button type="button" onclick="login()" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
<script>
	$(function (){

		if(window.top!=window){
			window.top.location=window.location;
		}

		/*加载完页面清空用户名和密码*/
		$("#loginName").val("");
		$("#loginPassword").val("");

		$("#loginName").focus();/*页面加载完自动获得焦点*/

		/*用户登录如果敲回车键表示登录，执行登录方法*/
		$(window).keydown(function (key){
			if(key.keyCode == 13){
				//表示敲回车键，执行登录方法
				login();
			}
		});
	});

	/*普通的自定义方法一定要写在$(function(){})的外面*/
	function login() {
		$("#msg").val("");
		//$.trim(文本) 将文本的左右空格都删除
		if ($.trim($("#loginName").val()) == "" || $.trim($("#loginPassword").val()) == "") {
			$("#msg").text("用户名和密码不能为空");
		} else {
			$.ajax({
				url: "user/login.do",
				data: {
					username: $("#loginName").val(),
					password: $("#loginPassword").val(),
				},
				type: "post",
				dataType: "json",
				success:function (result){
					if(result.success){
						window.location.href="workbench/index.jsp";
					}else {
						alert(result.msg);
					}
				}
			});
		}
	}
</script>