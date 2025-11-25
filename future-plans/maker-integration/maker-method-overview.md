# MAKER Method: Research Overview

**Source**: [arXiv:2511.09030v1](https://arxiv.org/html/2511.09030v1)
**Title**: Massively Decomposed Agentic Processes
**Date Reviewed**: 2025-11-25
**Reviewer**: Rizwan

---

## Executive Summary

MAKER is a framework for solving extremely long-horizon tasks (1M+ steps) with zero-error guarantees through three core mechanisms:

1. **Maximal Agentic Decomposition** - Break tasks into smallest possible units (ideally single steps)
2. **First-to-Ahead-by-K Error Correction** - Voting-based consensus for each step
3. **Red-Flagging** - Filter unreliable outputs before voting

The system achieves logarithmic scaling Θ(s ln s) compared to exponential degradation in monolithic approaches.

---

## Core Principles

### 1. Maximal Decomposition

**Concept**: Rather than one agent handling entire complex tasks, decompose to "microagents" where each focuses on exactly one decision.

**Rationale**:
- Avoids context bloat that degrades autoregressive model performance
- Prevents error accumulation as prior outputs grow
- Each agent receives minimal context: current state + prior move only

**Implementation**:
- Task broken into m steps where m is maximized (ideally m=1 per microagent)
- Templating function φ converts inputs to prompts
- Parser ψ extracts actions and propagates state forward

### 2. First-to-Ahead-by-K Voting

**Concept**: Multiple agents independently generate solutions for each step. Collect samples until one candidate leads competitors by K votes.

**Algorithm**:
```
For each step:
  1. Sample multiple agent responses
  2. Count votes for each unique solution
  3. Continue sampling until one solution has K more votes than any competitor
  4. Select the winning solution
```

**Mathematical Properties**:
- Required votes grow logarithmically: Θ(ln s) where s = number of steps
- Overall cost scales as Θ(s ln s) - far superior to exponential degradation
- Generalizes sequential probability ratio test for reliability

**Key Insight**: Cost scales logarithmically with task length, enabling 1M+ step tasks

### 3. Red-Flagging Mechanism

**Concept**: Discard suspicious outputs before they enter the voting pool.

**Red-Flag Signals**:
- **Token length**: Responses exceeding ~700 tokens (indicates confusion/rambling)
- **Format errors**: Incorrectly structured outputs
- **Correlation with reasoning errors**: These signals strongly predict mistakes

**Impact**:
- Reduces per-step error rates
- Minimizes correlated errors across steps
- Improves voting efficiency by filtering noise

---

## Implementation Architecture

### Core Algorithms

**Generate_Solution**:
```
for each step in task:
  solution = Do_voting(current_state)
  current_state = apply(solution, current_state)
return final_state
```

**Do_Voting**:
```
votes = {}
while not has_winner(votes, K):
  response = Get_vote(current_state)
  if response not null:
    votes[response] += 1
return highest_voted(votes)
```

**Get_Vote**:
```
response = sample_agent(current_state)
if is_red_flagged(response):
  return null
return parse(response)
```

### Key Components

1. **State Management**: Minimal context per step
2. **Templating (φ)**: Convert state to agent prompts
3. **Parsing (ψ)**: Extract structured actions from responses
4. **Vote Aggregation**: Track consensus with first-to-ahead-by-K
5. **Red-Flag Filter**: Detect and discard unreliable outputs

---

## Comparison to Standard Approaches

| Aspect | Standard Agentic | MAKER |
|--------|-----------------|-------|
| **Granularity** | Coarse (few agents) | Extreme (m=1 steps) |
| **Error Correction** | Ad-hoc or none | Systematic voting |
| **Context Growth** | Accumulates | Minimal per step |
| **Error Scaling** | Exponential | Logarithmic |
| **Cost Scaling** | Variable | Θ(s ln s) |
| **Error Tolerance** | 1-2% typical | Zero errors target |

**Standard workflow issues**:
- Single monolithic agents prone to exponential error accumulation
- Decomposition without systematic error correction
- Context bloat degrades performance

**MAKER advantages**:
- Principled voting at each granular step
- Correlated error detection and mitigation
- Scales efficiently while maintaining zero-error solutions

---

## Application to Frappe-Builder Module

### Current Architecture

**Agents** (8 specialized):
- frappe-nexus-sidecar (specialist orchestration)
- frappe-architect-sidecar (solution design)
- frappe-planner-sidecar (task planning)
- frappe-dev-sidecar (implementation)
- frappe-debugger-sidecar (issue diagnosis)
- doc-writer-sidecar (documentation)
- qa-specialist-sidecar (testing)
- erpnext-ba-sidecar (business analysis)

**Workflows** (11+):
- analyze-requirements
- design-solution
- implement-feature
- create-roadmap
- sequence-tasks
- diagnose-issue
- generate-tests
- review-code
- create-guide
- prepare-release
- (more...)

### Integration Challenges

**Challenge 1: Single-Specialization Agents**
- MAKER assumes multiple agents can vote on same task
- Frappe-builder has 1 agent per specialization
- **Solution needed**: How to generate multiple votes from single specialized agent?

**Challenge 2: Task Granularity**
- Current workflows operate at feature/solution level
- MAKER requires single-step decomposition
- **Solution needed**: How to break Frappe development into atomic steps?

**Challenge 3: Voting Mechanics**
- MAKER uses first-to-ahead-by-K consensus
- Single specialized agents can't naturally compete
- **Solution needed**: Voting strategy for non-competing specialists

**Challenge 4: Red-Flagging Adaptation**
- MAKER flags >700 tokens and format errors
- Frappe outputs (BRDs, TSDs, code) legitimately exceed 700 tokens
- **Solution needed**: Domain-specific red-flag criteria

---

## Potential Integration Strategies

### Strategy A: Intra-Agent Voting
- Single agent generates multiple solutions per step
- Vote among its own outputs
- Pros: No new agents needed
- Cons: Less diversity in voting pool

### Strategy B: Workflow Decomposition Layer
- Create MAKER orchestration workflow
- Breaks high-level tasks into atomic steps
- Routes steps to appropriate specialists
- Aggregates results with voting
- Pros: Preserves existing agents
- Cons: Complex orchestration logic

### Strategy C: Cross-Workflow Validation
- Multiple workflows solve same problem differently
- Vote among workflow outputs
- Pros: Leverages existing diversity
- Cons: Heavyweight, not per-step

### Strategy D: Step-Level Task Engine
- Core infrastructure for decomposition + voting
- Any workflow can invoke for high-stakes decisions
- Pros: Flexible, reusable
- Cons: Requires careful design

---

## Next Steps

1. **Decision**: Choose integration strategy aligned with existing architecture
2. **Design**: Architect voting mechanics for single-specialization agents
3. **Prototype**: Build proof-of-concept for high-stakes workflow
4. **Validate**: Test error reduction and cost scaling
5. **Expand**: Roll out to additional workflows

---

## Open Questions

1. How to generate voting diversity from single specialized agent?
2. What constitutes "atomic step" in Frappe development context?
3. What are domain-specific red-flag criteria for Frappe outputs?
4. Which workflows benefit most from MAKER integration?
5. How to balance MAKER overhead vs. error reduction benefits?
6. Can we achieve near-zero errors without full MAKER implementation?

---

## References

- **Paper**: [MAKER: Massively Decomposed Agentic Processes](https://arxiv.org/html/2511.09030v1)
- **Related Concepts**: Sequential Probability Ratio Test, Multi-Agent Consensus, Error-Correcting Codes
- **BMad Context**: Custom module at `/home/riz/frappe-bench/.bmad/custom/modules/frappe-builder`
