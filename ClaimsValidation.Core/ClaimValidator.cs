using System;
using System.Collections.Generic;
using System.Text;

namespace ClaimsValidation.Core;

public class ClaimValidator{
    public ValidationResult Validate(
        Claim claim,
        Member member,
        decimal coverageLimit){

        ArgumentNullException.ThrowIfNull(claim);
        ArgumentNullException.ThrowIfNull(member);

        var reasons = new List<string>();

        if (string.IsNullOrWhiteSpace(claim.ClaimId)){
            reasons.Add("MISSING_CLAIM_ID");
        }

        if (string.IsNullOrWhiteSpace(claim.MemberId)){
            reasons.Add("MISSING_MEMBER_ID");
        }

        if (string.IsNullOrWhiteSpace(claim.ProviderId)){
            reasons.Add("MISSING_PROVIDER_ID");
        }

        if (string.IsNullOrWhiteSpace(claim.ServiceType)){
            reasons.Add("MISSING_SERVICE_TYPE");
        }

        if (claim.ServiceDate.Date < member.CoverageStart.Date ||claim.ServiceDate.Date > member.CoverageEnd.Date){
            reasons.Add("COVERAGE_INACTIVE");
        }

        if (claim.Amount <= 0){
            reasons.Add("INVALID_AMOUNT");
        }

        if (claim.Amount > coverageLimit){
            reasons.Add("COVERAGE_LIMIT_EXCEEDED");
        }

        return new ValidationResult{
            IsValid = reasons.Count == 0,
            Reasons = reasons
        };
    }
}
