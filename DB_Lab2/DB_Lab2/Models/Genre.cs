namespace DB_Lab2.Models;

public class Genre
{
    [Key]
    public Guid Id { get; set; }

    [Required(ErrorMessage = "Genre name is required.")]
    public string Name { get; set; }

    public string Description { get; set; }
}
