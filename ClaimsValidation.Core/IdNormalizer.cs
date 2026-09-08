using System;
using System.Collections.Generic;
using System.Text;

namespace ClaimsValidation.Core;

public static class IdNormalizer{
    public static string Normalize(string? value){
        return (value ?? "").Trim().ToUpperInvariant();
    }
}