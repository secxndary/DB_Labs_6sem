namespace DB_Lab2.Models;

public class OrderDate
{
    [Required(ErrorMessage = "Start date is required.")]
    public DateTime DateStart { get; set; }

    [Required(ErrorMessage = "End date is required.")]
    public DateTime DateEnd { get; set; }
}
