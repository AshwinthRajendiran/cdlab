#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdbool.h>

bool isOperator(const char *str) {
    const char *operators[] = {
        "+", "-", "*", "/", "%", "=", "==", "!=", "<", "<=", ">", ">=", "&&", "||", "!"
    };
    int n = sizeof(operators) / sizeof(operators[0]);
    for (int i = 0; i < n; i++) {
        if (strcmp(str, operators[i]) == 0)
            return true;
    }
    return false;
}

bool nfa_identifier(const char *str, int i, bool print) {
    if (i == 0) {
        if (isalpha(str[i]) || str[i] == '_') {
            if (print) printf("Transition: q0 -> q1 (Letter/_ found: %c)\n", str[i]);
            return nfa_identifier(str, i + 1, print);
        } else {
            return false;
        }
    } else {
        if (str[i] == '\0') return true;
        if (isalnum(str[i]) || str[i] == '_') {
            if (print) printf("Transition: q1 -> q1 (Letter/Digit/_ found: %c)\n", str[i]);
            return nfa_identifier(str, i + 1, print);
        }
        return false;
    }
}

bool nfa_constant(const char *str, int i, bool hasDecimal, bool print) {
    if (str[i] == '\0') {
        return i > 0 && str[i - 1] != '.';
    }

    if (isdigit(str[i])) {
        if (i == 0 && print) printf("Transition: q0 -> q2 (Digit found: %c)\n", str[i]);
        else if (print) printf("Transition: q2/q4 -> q2/q4 (Digit found: %c)\n", str[i]);
        return nfa_constant(str, i + 1, hasDecimal, print);
    } else if (str[i] == '.' && !hasDecimal) {
        if (print) printf("Transition: q2 -> q3 (Decimal point found)\n");
        return nfa_constant(str, i + 1, true, print);
    } else {
        return false;
    }
}

void simulateNFA(const char *str) {
    printf("Simulating NFA for: %s\n", str);

    bool accepted = false;

    // Try Identifier
    if (nfa_identifier(str, 0, false)) {
        nfa_identifier(str, 0, true);
        printf("Final State: q1 (ACCEPT - Identifier)\n");
        accepted = true;
    }

    // Try Constant
    else if (nfa_constant(str, 0, false, false)) {
        nfa_constant(str, 0, false, true);
        if (strchr(str, '.')) {
            printf("Final State: q4 (ACCEPT - Decimal Constant)\n");
        } else {
            printf("Final State: q2 (ACCEPT - Integer Constant)\n");
        }
        accepted = true;
    }

    // Try Operator
    else if (isOperator(str)) {
        printf("Transition: q0 -> q5 (Operator found: %s)\n", str);
        printf("Final State: q6 (ACCEPT - Operator)\n");
        accepted = true;

    }

    if (!accepted) {
        printf("Final State: REJECT (Invalid Token)\n");
    }
}

int main() {
    char input[50];
    printf("Enter a string: ");
    scanf("%s", input);
    simulateNFA(input);
    return 0;
}
