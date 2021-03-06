<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		//页面加载完毕后触发一个方法
		pageList(1,2);


		//创建——模态窗口
		$("#addBtn").click(function (){

			//过后台取数据
			$.ajax({
				url:"activity/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (userList){
					//List<User>: {{user1},{user2},...}
					var html="<option></option>";

					$.each(userList,function (i,n){
						html+="<option value='"+n.id+"'>"+n.name+"</option>"
					});

					$("#create-marketActivityOwner").html(html);//为选项框拼接

					var id="${user.id}"
					$("#create-marketActivityOwner").val(id);//为选项框设置默认id绑定的文本值
				}
			});
			//打开模态窗口
			$("#createActivityModal").modal("show");
		});

		$("#insertActivity").click(function (){
			$.ajax({
				url:"activity/insertAcyivity.do",
				data:{
					"owner" : $.trim($("#create-marketActivityOwner").val()),
					"name" : $.trim($("#create-name").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endDate").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val())
				},
				type:"post",
				dataType:"json",
				success:function (data){
					//data:{"success",true/false}
					if(data.success){
						//刷新市场活动信息列表(分页操作)
						pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						//清空表单数据,js对象有reset（）方法，单jquery没有;即将其转为js即可
						$("#create-form")[0].reset();
					}else {
						alert("添加失败");
					}
				}
			});
		});


		//修改——模态窗口
		$("#editBtn").click(function (){
			//获取所选复选框
			var $xz=$("input[name=xz]:checked")
			if($xz.length==0){
				alert("请选择要修改的市场活动");
			}else if($xz.length>1){
				alert("只能选择一条市场活动");
			}else {
				//获取所选复选框value值——id
				var id = $xz.val();
				//过后台取数据拿信息
				$.ajax({
					url:"activity/getUserActivity.do",
					data:{
						"id":id
					},
					type:"get",
					dataType:"json",
					success:function (data){
						/*
						* data{ "userList":[{},{}..] , "activity":{activity} }
						* */
						var html = "<option></option>"
						$.each(data.userList,function (i,n){
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						});
						$("#edit-owner").html(html);

						//加载activity信息
						$("#edit-id").val(data.activity.id);
						$("#edit-name").val(data.activity.name);
						$("#edit-owner").val(data.activity.owner);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-description").val(data.activity.description);

						//所有的值加载完毕打开模态窗口
						$("#editActivityModal").modal("show");
					}
				});
			}
		});

		//修改操作
		$("#update-activity").click(function (){
			$.ajax({
				url:"activity/updateActivity.do",
				data:{
					"id":$.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())
				},
				type:"get",
				dataType:"json",
				success:function (data){
					/*
					* data:true/false
					* */
					if(data){
						/*   pageList(1,2);

						两个参数是bootstrap提供的
						第一个：操作后停留在当前页
						第二个：操作后维持已经设置好的每页展现的记录
						pageList($("#activityPage").bs_pagination('getOption','currentPage'),
								 $("#activityPage").bs_pagination('getOption','rowsPerPage'));
						*/
						pageList($("#activityPage").bs_pagination('getOption','currentPage'),
								$("#activityPage").bs_pagination('getOption','rowsPerPage'));
					}else {
						alert("修改失败");
					}

					//关闭窗口
					$("#editActivityModal").modal("hide");
				}
			});
		});

		//查询按钮
		$("#search-activity").click(function (){
			/*只有点击查询按钮，将数据保存起来*/
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startDate").val()))
			$("#hidden-endDate").val($.trim($("#search-endDate").val()))
			pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
		});

		//加载日历插件
		$(".time").datetimepicker({
			minView:"month",
			language:'zh-CN',
			format:'yyyy-mm-dd',
			autoclose:true,
			todayBtn:true,
			pickerPosition:"bottom-left"
		});

		//全选功能
		$("#qx").click(function (){
			$("input[name=xz]").prop("checked",this.checked);
		});

		/*通过单个勾选框操作 全选勾选框，由于单个勾选框是动态拼接生产的不能直接使用clik()方法，对于动态生成的用on()方法
			语法：$(需要绑定的有效外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
		*/
		$("#activityBody").on("click",$("input[name=xz]"),function (){
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});

		//删除
		$("#deleteBtn").click(function (){
			//找到复选框中所有挑勾的复选框对象
			var $xz=$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择需要删除的记录")
			}else {
				if(confirm("确定删除所选中的记录吗？")){
					//允许批量操作，可能存在同一个参数有多个数据的情况，而json不允许重复，所以采用传统传参
					var param="";
					for(var i=0;i<$xz.length;i++){
						//$xz[i].value
						param+="id="+$($xz[i]).val();
						if(i<$xz.length-1){
							param+="&";
						}
					}
					//alert(param)
					$.ajax({
						url:"activity/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data){
							if (data.success=true){
								alert("删除成功")
								//刷新市场活动列表
								pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
							}else {
								alert("删除失败")
							}
						}
					})
				}
			}
		})

	});



	//分页:"市场活动"加载完毕页面时、增删改后、查询时、点击分页组件后
	function pageList (pageNo,pageSize){

		//将全选的复选框的勾清除
		$("#qx").prop("checked",false);

		//查询前，将数据框的数据改为隐藏域保存的数据
		$("search-name").val($.trim($("#hidden-name").val()))
		$("search-owner").val($.trim($("#hidden-owner").val()))
		$("search-startDate").val($.trim($("#hidden-startDate").val()))
		$("search-endDate").val($.trim($("#hidden-endDate").val()))

		$.ajax({
			url:"activity/searchActivity.do",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val())
			},
			type:"post",
			dataType:"json",
			success:function (data){
				/*
				我们需要的市场活动信息列表：
				[{市场活动1}，{市场活动2}，{市场活动3}...]
				分页插件要的：
				data:{ “total”：100，“dataList”：[{市场活动1}，{市场活动2}，{市场活动3}...] }
				 */
				var html="";
				$.each(data.dataList,function (i,n){
					html+='<tr class="active">';
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'" /></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.startDate+'</td>';
					html+='<td>'+n.endDate+'</td>';
					html+='</tr>';
				})

				$("#activityBody").html(html);

				//结合分页插件
				var totalPages = data.total%pageSize==0? data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数
					visiblePageLinks: 5, // 显示几个卡片
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					/*该回调函数是在点击分页组件时候触发的*/
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		});
	}
</script>

</head>
<body>
<%--影藏域记录--%>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form  class="form-horizontal" role="form" id="create-form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<%--<c:forEach items="${userList}" var="user">
										<option id="${user.id}">${user.name}</option>
									</c:forEach>--%>
								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" name="name" class="form-control" id="create-name">
                            </div>
						</div>
																<%--form-control time col-sm-2 control-label--%>
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="button" class="form-control time" id="create-startTime" name="startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="button" class="form-control time" id="create-endTime" name="endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost" name="cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="insertActivity">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<%--隐藏域保存id--%>
						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" >
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<%--
								关于文本域 textarea：
								1.一定要以标签对的形式呈现，文本紧挨标签
								2.textarea是属于表单元素范畴，为其取值和赋值统一使用 .val() 方法，比较特殊而不是使用 .html()
								--%>
								<textarea class="form-control" rows="3" id="edit-description"><%--value--%></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="update-activity">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name"/>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="search-activity" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn" <%--data-toggle="modal" data-target="#createActivityModal"--%>><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" <%--data-toggle="modal" data-target="#editActivityModal"--%>><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<c:forEach items="${activityList}" var="activity">
							<tr class="active">
								<td><input type="checkbox" /></td>
								<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbencch/activity/detail.jsp';">${activity.name}</a></td>
								<td>${activity.owner}</td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
							</tr>
						</c:forEach>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#" id="2">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>