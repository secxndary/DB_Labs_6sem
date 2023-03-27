namespace DB_Lab2.Models;

public class Order
{
    [Key]
    public Guid Id { get; set; }

    [Required(ErrorMessage = "Book Id is required.")]
    public Guid BookId { get; set; }

    [Required(ErrorMessage = "Cusomer Id is required.")]
    public Guid CustomerId { get; set; }

    [Required(ErrorMessage = "Order date is required.")]
    public DateTime OrderDate { get; set; }

    [Required(ErrorMessage = "Quantity is required.")]
    public int Qty { get; set; }

    [Required(ErrorMessage = "Amount is required.")]
    public float Amount { get; set; }
}
