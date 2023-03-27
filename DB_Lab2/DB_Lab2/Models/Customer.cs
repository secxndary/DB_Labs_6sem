namespace DB_Lab2.Models;

public class Customer
{
    [Key]
    public Guid Id { get; set; }

    [Required(ErrorMessage = "Company Name is required.")]
    public string CompanyName { get; set; }

    public string Address { get; set; }

    [Phone]
    public string Phone { get; set; }


}
