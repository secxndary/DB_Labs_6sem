using System.Data;

namespace DB_Lab2.Services;

public class AuthorService
{

    private readonly IConfiguration _configuration;
    private readonly string connectionString;

    public AuthorService(IConfiguration configuration)
    {
        _configuration = configuration;
        connectionString = _configuration.GetConnectionString("Default");
    }



    public List<Author> GetAuthors()
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var authors = new List<Author>();
            var sqlExpression = "SELECT * FROM Authors";
            var sqlCommand = new SqlCommand(sqlExpression, conn);
            var sqlDataAdapter = new SqlDataAdapter(sqlCommand);
            var dataTable = new DataTable();

            conn.Open();
            sqlDataAdapter.Fill(dataTable);

            for (var i = 0; i < dataTable.Rows.Count; i++)
            {
                var item = new Author();
                item.Id = Guid.Parse(dataTable.Rows[i]["Id"].ToString());
                item.Name = dataTable.Rows[i]["Name"].ToString();
                item.Surname = dataTable.Rows[i]["Surname"].ToString();
                item.Country = dataTable.Rows[i]["Country"].ToString();
                item.DateOfBirth = DateTime.Parse(dataTable.Rows[i]["Date_Of_Birth"].ToString());
                authors.Add(item);
            }

            return authors;
        }
    }


    public async void AddAuthor(Author author)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            author.Id = Guid.NewGuid();
            var sqlExpression = $"INSERT INTO Authors(ID, NAME, SURNAME, COUNTRY, DATE_OF_BIRTH) VALUES " +
                $"('{author.Id}', N'{author.Name}', N'{author.Surname}', N'{author.Country}', '{author.DateOfBirth}');";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }


    public async void UpdateAuthor(Author author)
    {
        author.DateOfBirth.AddHours(-author.DateOfBirth.Hour);
        author.DateOfBirth.AddMinutes(-author.DateOfBirth.Minute);
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var sqlExpression = $"UPDATE Authors SET NAME = N'{author.Name}', SURNAME = N'{author.Surname}', " +
                $"COUNTRY = N'{author.Country}', DATE_OF_BIRTH = '{author.DateOfBirth}' WHERE ID = '{author.Id}'";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }


    public async void DeleteAuthor(Guid? id)
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            var sqlExpression = $"DELETE FROM Authors WHERE ID = '{id}'";
            var sqlCommand = new SqlCommand(sqlExpression, conn);

            conn.Open();
            await sqlCommand.ExecuteNonQueryAsync();
        }
    }


    public Author GetAuthor(Guid? id) => GetAuthors().Find(x => x.Id == id);
}
