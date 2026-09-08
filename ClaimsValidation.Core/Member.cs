using System;
using System.Collections.Generic;
using System.Text;

namespace ClaimsValidation.Core;

public class Member{
    public string MemberId { get; set; } = "";
    public DateTime CoverageStart { get; set; }
    public DateTime CoverageEnd { get; set; }
    public string PlanType { get; set; } = "";
}
