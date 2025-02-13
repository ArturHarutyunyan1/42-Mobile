
function calculateExpression(input: string)
{
    const isOperator = (char: string) => ['+', '-', 'x', '/', '%'].includes(char);
    const tokens: (string | number)[] = [];
    let num = "";

    for (let i = 0; i < input.length; i++)
    {
        if (isOperator(input[i]))
        {
            if (num)
            {
                tokens.push(parseFloat(num));
                num = "";
            }
            if (input[i] === '-' && (i === 0 || isOperator(input[i - 1])))
                num += '-';
            else
                tokens.push(input[i]);
        }
        else
            num += input[i]
    }
    if (num)
        tokens.push(parseFloat(num));
    let stack: (string | number)[] = [];
    for (let i = 0; i < tokens.length; i++)
        {
        if (tokens[i] === 'x' || tokens[i] === '/' || tokens[i] === '%')
            {
            const left = stack.pop() as number;
            const right = tokens[++i] as number;
            if (tokens[i - 1] === 'x') {
                stack.push(left * right);
            } else if (tokens[i - 1] === '/') {
                if (right === 0) return "ERROR";
                else stack.push(left / right);
            } else if (tokens[i - 1] === '%') {
                if (right === 0) return "ERROR";
                else stack.push(left % right);
            }
        } else {
            stack.push(tokens[i]);
        }
    }
    let result = stack[0] as number;
    for (let i = 1; i < stack.length; i+=2)
    {
        const operator = stack[i] as string;
        const right = stack[i + 1] as number;
        result = operator === '+' ? result + right : result - right;
    }    
    return (result);
}

export const handlePress = (
    value: string,
    input: string,
    setInput: (newInput: string) => void,
    setResult: (newResult: string) => void,
    ) => {
        const lastChar = input[input.length - 1];
        const isOperator = (char: string) => ['+', '-', 'x', '/', '%'].includes(char);

        if (input == '' && isOperator(value))
            return;
        if (isOperator(lastChar) && isOperator(value))
            setInput(input.slice(0, -1) + value);
        else if (value === 'AC')
        {
            setInput('');
            setResult('');
        }
        else if (value === 'C')
        {
            setInput(input.slice(0, -1));
            setResult(input.slice(0, -1));
        }
        else if (value === '=')
        {
            const result = calculateExpression(input).toString();
            setResult('');
            setInput(result);
        }
        else if (value == '+/-')
        {
            
        }
        else
        {
            setInput(input + value);
            const result = calculateExpression(input + value).toString();
            if (!isNaN(parseFloat(result)))
                setResult(result);
        }
};