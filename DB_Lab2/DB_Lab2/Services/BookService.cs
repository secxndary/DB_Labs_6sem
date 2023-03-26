using System.Data;
using DB_Lab2.Models;

namespace DB_Lab2.Services;

public class BookService
{
    private readonly IConfiguration _configuration;
    private readonly string connectionString;


    public BookService(IConfiguration configuration)
    {
        _configuration = configuration;
        connectionString = _configuration.GetConnectionString("Default");
    }



    public List<Book> GetBooks()
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var books = new List<Book>();
            var sqlExpression = "SELECT * FROM BOOKS";
            var sqlCommand = new SqlCommand(sqlExpression, conn);
            var sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            var dataTable = new DataTable();

            conn.Open();
            sqlDataAdapter.Fill(dataTable);

            for (var i = 0; i < dataTable.Rows.Count; i++)
            {
                var item = new Book();
                item.Id = Guid.Parse(dataTable.Rows[i]["Id"].ToString());
                item.AuthorId = Guid.Parse(dataTable.Rows[i]["Author_Id"].ToString());
                item.Title = dataTable.Rows[i]["Title"].ToString();
                item.Pages = int.Parse(dataTable.Rows[i]["Pages"].ToString());
                books.Add(item);
            }

            return books;
        }
    }

    public Book GetBook(Guid? id) => GetBooks().Find(x => x.Id == id);


    public async void AddBook(Book book)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            book.Id = Guid.NewGuid();
            var sqlExpression = $"INSERT INTO Books(ID, TITLE, PAGES, AUTHOR_ID) VALUES " +
                $"('{book.Id}', N'{book.Title}', {book.Pages}, '{book.AuthorId}');" ;
            var sqlCommand = new SqlCommand(sqlExpression, conn);
            
            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }


    public async void UpdateBook(Book book)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var sqlExpression = $"UPDATE Books SET TITLE = N'{book.Title}', PAGES = {book.Pages}, " +
                $"AUTHOR_ID = '{book.AuthorId}' WHERE ID = '{book.Id}'";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }


    public async void DeleteBook(Guid? id)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var sqlExpression = $"DELETE FROM Books WHERE ID = '{id}'";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }
}
