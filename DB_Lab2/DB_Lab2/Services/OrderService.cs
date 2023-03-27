using System.Data;
using System.Globalization;

namespace DB_Lab2.Services;

public class OrderService
{
    private readonly IConfiguration _configuration;
    private readonly string connectionString;

    public OrderService(IConfiguration configuration)
    {
        _configuration = configuration;
        connectionString = _configuration.GetConnectionString("Default");
    }



    public List<Order> GetOrders(OrderDate orderDate)
    {
        var dateStart = orderDate.DateStart;
        var dateEnd = orderDate.DateEnd;
        var dateStartSql = $"{dateStart.Month}.{dateStart.Day}.{dateStart.Year}";
        var dateEndSql = $"{dateEnd.Month}.{dateEnd.Day}.{dateEnd.Year}";
        var defaultDate = new DateTime(1, 1, 1, 0, 0, 0);
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var orders = new List<Order>();
            var sqlExpression = (dateStart == defaultDate && dateEnd == defaultDate) ? "SELECT * FROM Orders" : 
                $"SELECT * FROM Orders WHERE Order_Date BETWEEN '{dateStartSql}' AND '{dateEndSql}';";
            var sqlCommand = new SqlCommand(sqlExpression, conn);
            var sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            var dataTable = new DataTable();

            conn.Open();
            sqlDataAdapter.Fill(dataTable);

            for (var i = 0; i < dataTable.Rows.Count; i++)
            {
                var item = new Order();
                item.Id = Guid.Parse(dataTable.Rows[i]["Id"].ToString());
                item.BookId = Guid.Parse(dataTable.Rows[i]["Book_Id"].ToString());
                item.CustomerId = Guid.Parse(dataTable.Rows[i]["Customer_Id"].ToString());
                item.OrderDate = DateTime.Parse(dataTable.Rows[i]["Order_Date"].ToString());
                item.Qty = int.Parse(dataTable.Rows[i]["Qty"].ToString());
                item.Amount = float.Parse(dataTable.Rows[i]["Amount"].ToString());
                orders.Add(item);
            }

            return orders;
        }
    }
}
