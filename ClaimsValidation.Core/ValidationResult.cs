using System;
using System.Collections.Generic;
using System.Text;

namespace ClaimsValidation.Core;

public class ValidationResult{
    public bool IsValid { get; set; }

    public List<string> Reasons { get; set; } = new();

    public string ReasonText{
        get {
            return string.Join(", ", Reasons.Distinct().OrderBy(reason => reason));
        }
    }
}
