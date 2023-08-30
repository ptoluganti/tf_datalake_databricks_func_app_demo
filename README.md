# tf_datalake_databricks_func_app_demo


``` dotnet
public class HttpResponseBody<T>
    {
        public bool IsValid { get; set; }
        public T Value { get; set; }

        public IEnumerable<ValidationResult> ValidationResults { get; set; }
    }

    public static class HttpRequestExtensions
    {
        public static async Task<HttpResponseBody<T>> GetBodyAsync<T>(this HttpRequest request)
        {
            var body = new HttpResponseBody<T>();
            var bodyString = await request.ReadAsStringAsync();
            body.Value = JsonConvert.DeserializeObject<T>(bodyString);

            var results = new List<ValidationResult>();
            body.IsValid = Validator.TryValidateObject(body.Value, new ValidationContext(body.Value, null, null), results, true);
            body.ValidationResults = results;
            return body;
        }
    }

    var body = await req.GetBodyAsync<Movie>();
    if (body.IsValid)
    {
       return new OkObjectResult(body.Value);
    }
    else
    {
       return new BadRequestObjectResult($"Model is invalid: {string.Join(", ", body.ValidationResults.Select(s => s.ErrorMessage).ToArray())}");
    }


var sb = new StringBuilder();
    var identity = req.HttpContext?.User?.Identity as ClaimsIdentity;
    sb.AppendLine($"IsAuthenticated: {identity?.IsAuthenticated}");
    sb.AppendLine($"Identity name: {identity?.Name}");
    sb.AppendLine($"AuthenticationType: {identity?.AuthenticationType}");
    foreach (var claim in identity?.Claims)
    {
        sb.AppendLine($"Claim: {claim.Type} : {claim.Value}");
    }
        return new OkObjectResult(sb.ToString());
```
