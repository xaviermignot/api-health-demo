public interface IDepartmentService
{
    IEnumerable<Department> GetDepartments();

    Department GetDepartment(string id); 
}