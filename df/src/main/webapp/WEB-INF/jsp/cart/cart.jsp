<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="com.ssm.domain.GoodsInfo" %>
<!DOCTYPE html>
<html>
<head>
 <%@ include file="../header.jsp" %>
</head>
<body>
 <%@ include file="../bhead.jsp" %>
 <script>
function calculateTotal() {
	// 需要统计的值
	var sumTotal = 0; // 商品总价钱
	var countGood = 0; // 商品总数量

	$('.col07').each(function(index, element) {
		// 获取数量
		count = parseInt($(element).prev().find('input').val());
		// 获取价格
		price = parseFloat($(element).prev().prev().text());
		// 小计
		total = count * price;
		// 更新小计的显示内容
		$(element).text(total.toFixed(2)+'元');
		// 计算总价钱和总数量
		if($(element).siblings('.col01').children('input').prop('checked')) {
			sumTotal += total;
			countGood++;
		}
		// if($(element).siblings('.col01').children('input').prop('checked')) {
		// 	total=parseFloat($(element).prev().prev().text())+parseInt($(element).prev().find('input').val());	
		// 	sumTotal += total;
		// 	countGood++;
		// }
		// else  {
		// 	total=parseFloat($(element).prev().prev().text())+parseInt($(element).prev().find('input').val());	
		// 	sumTotal -= total;
		// 	countGood--;
		// }
	});
	// 更新显示的总价钱和总数量
	$('.countGood').text(countGood);
	$('#sumtotal').text(sumTotal.toFixed(2));
}
$(function(){
	calculateTotal();
	$(".settlements").children(".col01").children("input").click(function(){
		if($(this).prop("checked")){
			$(".cart_list_td").children(".col01").children("input").prop("checked",true);
		}else{
			$(".cart_list_td").children(".col01").children("input").prop("checked",false);
		}
		calculateTotal();
	});
	$(".cart_list_td").children('.col01').children("input").click(function(){
		// 当前有多少个勾选框被选中
		selectedGood = $(".cart_list_td").children('.col01').children("input:checked").length;
		// 总共有多少个单独的勾选框
		countGood = $(".cart_list_td").children('.col01').children("input").length;
		// 如果全部选中 则勾选全选中的勾
		if (selectedGood == countGood) {
			$(".settlements").children(".col01").children('input').prop("checked", true);
		} else {
			$(".settlements").children(".col01").children('input').prop("checked", false);
		}
		// 重新计算总价
		calculateTotal();
	});
});
$(function(){
	$('.num_show').blur(function(event) {
		num = $(this).val();
		if (num > 99) {
			num = 99;
		} else if (num < 1) {
			num = 1;
		}
		$(this).val(num);
		console.log($(this).parent().parent().prev().text());
		price = $(this).parent().parent().prev().children("span").text();
		console.log(price);
		total = price * num;
		price = $(this).parent().parent().next().text(total.toFixed(2) + '元');
		calculateTotal();
		dom = $(this).parent().parent().parent().attr("id");
		format(num,dom);
	});
});
function cart_del(cart_id) {
	ret = confirm("确定要删除吗？");
	if(ret) {
		url = "${pageContext.request.contextPath}/cart/delete" + cart_id;
		$.get(url, function(data){
			var data1 = data.substring(1,data.length-1);
			if(data1 == 0) {		
				url = "${pageContext.request.contextPath}/cart/getnum";
				$.get(url, function(data){
					var data1 = data.substring(1,data.length-1);
					$("#show_count").text(data1);
				});
				$("ul").remove("#" + cart_id);
				calculateTotal();
			}
		});
	}
}
function add(dom,price)
{

num = $("#b"+dom+" .num_show").val();
if (num<99){
	num++;
	$("#b"+dom+" .num_show").val(num);
}
total = price*num;
//$("#c"+dom).text(total.toFixed(2)+ '元');
calculateTotal();
format(num,dom);
}
function minus(dom,price)
{
num = $("#b"+dom+" .num_show").val();
if (num>1){
	num--;
	$("#b"+dom+" .num_show").val(num);
}
total = price*num;
//$("#c"+dom).text(total.toFixed(2)+ '元');
calculateTotal();
format(num,dom);
}
function format(count,cart_id){
		//cart_id = $(this).parents(".cart_list_td").attr("id");
		url = "${pageContext.request.contextPath}/cart/edit" + cart_id + "_" + count
		$.get(url, function(data){
			if(data.ok == 1) {
				alert("发生了错误");
			}

});
	}

</script>
	<div class="total_count">全部商品<em class="countGood">0</em>件</div>	
	<ul class="cart_list_th clearfix">
		<li class="col01">商品名称</li>
		<li class="col02">商品单位</li>
		<li class="col03">商品价格</li>
		<li class="col04">数量</li>
		<li class="col05">小计</li>
		<li class="col06">操作</li>
	</ul>
					<c:forEach items="${cartlist}" var="item" varStatus="status">
	<ul class="cart_list_td clearfix" id="${item.getId()}">
		<li class="col01"><input type="checkbox" name="" checked></li>
		<li class="col02"><img src="${pageContext.request.contextPath}${item.getGpic()}"></li>
		<li class="col03">${item.getGtitle()}<br><em>${item.getGunit()}</em></li>
		<li class="col04">${item.getGunit()}</li>
		<li class="col05"><span>${item.getGprice()}</span>元</li>
		<li class="col06">
			<div class="num_add" id="b${item.getId()}">
				<a href="javascript:add(${item.getId()},${item.getGprice()});" class="add fl">+</a>
				<input type="text" class="num_show fl" value="${cartcount.get(status.index).getCount() }">	
				<a href="javascript:minus(${item.getId()},${item.getGprice()});" class="minus fl">-</a>	
			</div>
		</li>
		<li class="col07" id="c${item.getId()}">${item.getGprice()}</li>
		<li class="col08"><a href="javascript:cart_del(${item.getId()});">删除</a></li>
	</ul>
</c:forEach>
	

	<ul class="settlements">
		<li class="col01"><input type="checkbox" name="" checked=""></li>
		<li class="col02">全选</li>
		<li class="col03">合计(不含运费)：<span>¥</span><em id="sumtotal"></em><br>共计<b class="countGood"></b>件商品</li>
		<li class="col04"><a href="/order/">去结算</a></li>
	</ul>
 </body>
 </html>