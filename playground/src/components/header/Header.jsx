import icon from "../../assets/icon.svg";

export default function Header() {
  return (
    <div className="px-5 py-3 border-b flex justify-between items-center">
      <div className="flex gap-4 items-center">
        <img src={icon} width={42} alt="icon" />
        <div className="font-semibold text-xl">Oracle SQL Parser</div>
      </div>
      <div className="flex gap-4 text-4xl">
        <a href="https://www.npmjs.com/package/oracle-sql-parser">
          <i className="fa-brands fa-npm"></i>
        </a>
        <a href="https://github.com/1ilit/oracle-sql-parser">
          <i className="fa-brands fa-github"></i>
        </a>
      </div>
    </div>
  );
}
