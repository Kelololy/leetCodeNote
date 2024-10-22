

-- 175. 组合两个表
select p.firstName, p.lastName, a.city, a.state
from person p
left join address a on p.personId = a.PersonId;


--181. 超过经理收入的员工
select e.name Employee
from Employee e
where e.managerId is not null
and e.salary > (select salary from Employee e1 where e1.id = e.managerId );

--182. 查找重复的电子邮箱
select Email from person group by email  having count(email) >1;

--183. 从不订购的客户
select c.name  customers from Customers c
where not exists (select 1 from orders o where o.customerId = c.id);

--196. 删除重复的电子邮箱
delete from Person
where id not in (
 select a.id from ( select min(id) id from Person  group by email ) a
);

--197. 上升的温度
SELECT id FROM	Weather w
WHERE w.Temperature > ( SELECT w2.Temperature FROM Weather w2 WHERE w2.recordDate = w.recordDate-1 );

--511. 游戏玩法分析 I
select a.player_id as player_id , to_char(min(a.event_date),'yyyy-mm-dd')  as first_login
from Activity a
group by a.player_id
order by a.player_id;

-- 577. 员工奖金
select e.name as name , b.bonus as bonus from
Employee  e
left join Bonus b on e.empId = b.empId
where b.bonus is null or b.bonus <1000;

-- 584. 寻找用户推荐人
select c.name name  from Customer c
where c.referee_id != 2 or c.referee_id is null;

-- 586. 订单最多的客户
select * from (
select customer_number from Orders o
group by customer_number
order by count(customer_number) desc ) where rownum =1;

--595. 大的国家
select w.name,w.population,w.area from World w
where w.area>=3000000 or w.population >=25000000;

--596. 超过 5 名学生的课
select c.class from Courses c
group by c.class having count(1)>=5;

--607. 销售员
SELECT	s.NAME FROM
    SalesPerson s
WHERE
NOT EXISTS (
        SELECT 	1  FROM orders o
        WHERE o.sales_id = s.sales_id
          AND o.com_id = ( SELECT c.com_id FROM Company c WHERE c.NAME = 'RED' )
    );

--610. 判断三角形
SELECT x, y, z,
CASE  WHEN (x + y > z) AND (x + z > y) AND (y + z > x)
    THEN 'Yes' ELSE 'No' END AS triangle
FROM triangle;

--619. 只出现一次的最大数字
select max(num) num from
(select num  from MyNumbers
 group by num having count(num) =1  );

--620. 有趣的电影
select * from cinema c
where c.description != 'boring' and MOD(c.id, 2) != 0
order by c.rating desc;

--627. 变更性别
update Salary
set sex = decode(sex,'m','f','f','m');

-- 1050. 合作过至少三次的演员和导演
select a.actor_id, a.director_id from ActorDirector a
group by a.actor_id, a.director_id
having count(*) >=3;

-- 1068. 产品销售分析 I
select p.product_name, s.year, s.price from Sales s
left join Product p on  s.product_id = p.product_id;

--1075. 项目员工 I
select p.project_id, round(avg(e.experience_years),2) average_years from Project p
left join Employee e on e.employee_id= p.employee_id
group by p.project_id;

--1683. 无效的推文
select tweet_id from tweets s where length(s.content)>15

--1084. 销售分析III
select  distinct s.product_id,p.product_name from Sales s
left join Product p on s.product_id = p.product_id
where s.sale_date >= to_date('2019-01-01','yyyy-mm-dd')
and s.sale_date <= to_date('2019-03-31','yyyy-mm-dd')
and s.product_id not in ( select s2.product_id from Sales s2 where
s2.sale_date < to_date('2019-01-01','yyyy-mm-dd') or s2.sale_date > to_date('2019-03-31','yyyy-mm-dd') )

--1141. 查询近30天活跃用户数
select to_char(a.activity_date,'yyyy-mm-dd') day ,count (distinct a.user_id) active_users from Activity a
where a.activity_date <= to_date('2019-07-27','yyyy-mm-dd')
  and a.activity_date > to_date('2019-06-27','yyyy-mm-dd')
group by a.activity_date
order by a.activity_date ;

--1148. 文章浏览 I
select  distinct  v.author_id  id from Views v
where v.author_id = v.viewer_id
order by id;


--1179. 重新格式化部门表
select d.id , sum(DECODE(d.month,'Jan', d.revenue,null)) Jan_Revenue
     ,sum(DECODE(d.month,'Feb', d.revenue, null)) Feb_Revenue
     ,sum(DECODE(d.month,'Mar', d.revenue, null)) Mar_Revenue
     ,sum(DECODE(d.month,'Apr', d.revenue, null)) Apr_Revenue
     ,sum(DECODE(d.month,'May', d.revenue, null)) May_Revenue
     ,sum(DECODE(d.month,'Jun', d.revenue, null)) Jun_Revenue
     ,sum(DECODE(d.month,'Jul', d.revenue, null)) Jul_Revenue
     ,sum(DECODE(d.month,'Aug', d.revenue, null)) Aug_Revenue
     ,sum(DECODE(d.month,'Sep', d.revenue, null)) Sep_Revenue
     ,sum(DECODE(d.month,'Oct', d.revenue, null)) Oct_Revenue
     ,sum(DECODE(d.month,'Nov', d.revenue, null)) Nov_Revenue
     ,sum(DECODE(d.month,'Dec', d.revenue, null)) Dec_Revenue
from  Department d
group by d.id;
-- 第二种 行转列
select  * from Department
    pivot (SUM(REVENUE) for month in (
        'Jan' as "Jan_Revenue",
        'Feb' as "Feb_Revenue",
        'Mar' as "Mar_Revenue",
        'Apr' as "Apr_Revenue",
        'May' as "May_Revenue",
        'Jun' as "Jun_Revenue",
        'Jul' as "Jul_Revenue",
        'Aug' as "Aug_Revenue",
        'Sep' as "Sep_Revenue",
        'Oct' as "Oct_Revenue",
        'Nov' as "Nov_Revenue",
        'Dec' as "Dec_Revenue"
));

--1251. 平均售价
select p.product_id, case when sum(n.units) is null then 0
else round(sum(p.price*n.units)/ sum(n.units),2) end average_price
from Prices p
left join UnitsSold n on p.product_id= n.product_id
and  n.purchase_date >= p.start_date
and n.purchase_date <= p.end_date
group by p.product_id;

--1280. 学生们参加各科测试的次数
s.student_id,
s.student_name,
s.subject_name,
count(e.student_id) as attended_exams
from (select * from Students, Subjects) s
left join Examinations e
on s.student_id = e.student_id and s.subject_name = e.subject_name
group by s.student_id, s.student_name, s.subject_name
order by s.student_id, s.student_name;

--1327. 列出指定时间段内所有的下单产品
select product_name, sum(o.unit) unit from Products p
left join Orders  o on p.product_id= o.product_id
where o.order_date between to_date('2020-02-01','yyyy-mm-dd') and  to_date('2020-02-29','yyyy-mm-dd')
group by p.product_name, o.product_id  having sum(o.unit) >=100;




