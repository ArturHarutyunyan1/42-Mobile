
function calculateExpression(input: string)
{
    const isOperator = (char: string) => ['+', '-', '*', '/'].includes(char);
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
        if (tokens[i] === '*' || tokens[i] === '/')
        {
            const left = stack.pop() as number;
            const right = tokens[++i] as number;
            stack.push(tokens[i - 1] === '*' ? left * right : left / right)
        }
        else
            stack.push(tokens[i]);
    }
    let result = stack[0] as number;
    for (let i = 1; i < stack.length; i+=2)
    {
        const operator = stack[i] as string;
        const right = stack[i + 1] as number;
        result = operator === '+' ? right + result : right - result;
    }
    console.log(result);
    
    return (result);
}

export const handlePress = (value: string, input: string, setInput: (newInput: string) => void) => {
    const lastChar = input[input.length - 1];
    const isOperator = (char: string) => ['+', '-', '*', '/'].includes(char);

    if (input == '' && isOperator(value))
        return;
    if (isOperator(lastChar) && isOperator(value))
        setInput(input.slice(0, -1) + value);
    else if (value === '=')
        setInput(calculateExpression(input).toString());
    else
        setInput(input + value);
};