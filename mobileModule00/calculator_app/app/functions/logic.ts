export const handlePress = (value: string, input: string, setInput: (newInput: string) => void) => {
    setInput(input + value);
};