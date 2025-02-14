export const changePage = (index: number, pagerRef: React.RefObject<PagerView>, setPageIndex: React.Dispatch<React.SetStateAction<number>>) => {
    setPageIndex(index);
    if (pagerRef.current) {
      pagerRef.current.setPage(index);
    }
  };
  
  export const setCityName = (name: string, setName: React.Dispatch<React.SetStateAction<string>>) => {
    setName(name);
  };
  