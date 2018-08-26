package com.ssm.controller;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ssm.domain.Menu;
import com.ssm.domain.Menubar;
import com.ssm.domain.ShopInf;
import com.ssm.service.MenuService;
import com.ssm.service.MenubarService;
import com.ssm.service.ShopInfService;
import com.ssm.utils.StringtoMaps;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

//不一定命名为Inf，登录成功后，可写重定向过来，顺便通过session传用户信息，处理商家登录后逻辑

@Controller
//单例模式，自加
@Scope(value="prototype")
@RequestMapping("/shopInf")
public class ShopInfController {
    @Resource
    private ShopInfService shopInfService;
    @Resource 
    private MenubarService menubarService;
    @Resource 
    private MenuService menuService;
  //自写部分 
    @RequestMapping(value="/shopRegister",method=RequestMethod.POST)        // 请求映射 http://localhost:8080/springmvc-annotation/login.action
    public String goShopRegister(ShopInf shopInf,Model model) throws Exception {
    	//先导入username,password调用filter正则表达式判断(未完成)
    	shopInf = shopInfService.checkShopInfRegister(shopInf.getUserid(),shopInf.getShopname(),shopInf.getShopaddress(),shopInf.getTelephone());
    	return "shopInfregistersuccess";
    } 
    @RequestMapping(value="/setMenu",method=RequestMethod.GET)        // 请求映射 http://localhost:8080/springmvc-annotation/login.action
    public String setMenu(Menubar menubar,Model model,HttpServletResponse response) throws Exception {
    	menubar = menubarService.getMenubarByshopid(1);//session上获取shopid
    	System.out.println(menubar.getMenuname());
    	List<Menubar> mb = new ArrayList<Menubar>();  
    	mb.add(new Menubar(menubar.getMenuname(),menubar.getId(),menubar.getShopid()));
    	System.out.println(new Menubar(menubar.getMenuname(),menubar.getId(),menubar.getShopid()));
    	 String json = "";  
         JsonConfig jsonConfig = new JsonConfig();  
         if(mb!=null){  
         json = JSONArray.fromObject(mb, jsonConfig).toString();  
         json = json.substring(1,json.length()-1);         
         System.out.println(json.toString());       
         }else{  
             json="[]";  
         }  
         String layjson = "{\"code\":0,\"msg\":\"\",\"count\":1000,\"data\":["+json+"]}";
           System.out.println(layjson);
         JSONObject jsonj = JSONObject.fromObject(layjson);
         response.setCharacterEncoding("UTF-8");
         response.getWriter().print(jsonj);
         return null;     	
    }//转json格式
	@RequestMapping(value="/setMenunew",method=RequestMethod.GET)
	public String menusetnew(Menu menu,Model model,HttpServletResponse response,HttpServletRequest request) throws Exception {
		int page = Integer.parseInt(request.getParameter("page"));
		int limit = Integer.parseInt(request.getParameter("limit"));
		System.out.println(page+limit);
		List<List<Menu>> mu = menuService.selectAll(page, limit);
		System.out.println(mu);
		String json = "";  
        JsonConfig jsonConfig = new JsonConfig();  
        if(mu!=null){  
        json = JSONArray.fromObject(mu, jsonConfig).toString();  
        json = json.substring(1,json.length()-1);         
        System.out.println(json.toString());       
        }else{  
            json="[]";  
        }  
        String layjson = "{\"code\":0,\"msg\":\"\",\"count\":"+menuService.getcount()+",\"data\":["+json+"]}";
          System.out.println(layjson);
        JSONObject jsonj = JSONObject.fromObject(layjson);
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(jsonj);
		return null;		
	}
	@ResponseBody
	@RequestMapping(value="/selectdel",method=RequestMethod.POST)
	public void selectdel(@RequestParam("data[]") String[] data) throws Exception {

	System.out.println("删除方法被执行");
	menuService.selectDel(data);
	for(int i=0;i<data.length;i++) {
	System.out.println("删除了id为:"+data[i]+"的数据");
	}
		return ;
	}
	@ResponseBody
	@RequestMapping(value="/change",method=RequestMethod.POST)
	public String change(@RequestParam("data") String data,@RequestParam("id") String id,@RequestParam("menubarid") String menubarid,Menu menu) throws Exception {
		System.out.println(data);
		try {
			Map map = StringtoMaps.toData(data); //map传到实体类
			menu.setId((Integer)map.get("id"));
			menu.setMenubarid((Integer)map.get("menubarid"));
			menu.setName((String)map.get("name"));
			menu.setPrice((Double)map.get("price"));
			menu.setStatus((String)map.get("status"));
			System.out.println(map.get("id"));
			System.out.println("我是barid"+menubarid);
			menuService.change(menu.getId(), menu.getMenubarid(), menu.getName(), menu.getPrice(), menu.getStatus(), id,menubarid);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		System.out.println("chang方法被执行");
		return "success";
	}
	@ResponseBody              //能使return成功返回参数到success
	@RequestMapping(value="/insert",method=RequestMethod.POST)
	public String insert(@RequestParam("data") String data,Menu menu,HttpServletResponse response,Map map) throws Exception {
		System.out.println("插入方法被执行");
		try {
		map = StringtoMaps.toData(data); 
		menu.setId((Integer)map.get("id"));
		menu.setMenubarid((Integer)map.get("menubarid"));
		menu.setName((String)map.get("name"));
		menu.setPrice((Double)map.get("price"));
		menu.setStatus((String)map.get("status"));
		menuService.insert(menu.getId(), menu.getMenubarid(), menu.getName(), menu.getPrice(), menu.getStatus());
		}
	 catch (Exception e) {
		e.printStackTrace();
		return "fail";
	}
		return "success";
		}
}